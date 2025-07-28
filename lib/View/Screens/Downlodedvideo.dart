import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:sakthiexports/View/widgets/Shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:sakthiexports/Controller/Videocontroller.dart';
import 'package:sakthiexports/Theme/Fonts.dart';
import 'VideoPlayerfullscreen.dart';
import '../util/linecontainer.dart';

const String _aesKey = '32charslongencryptionkey12345678';
const String _aesIV = '1234567890abcdef';

List<int> aesDecrypt(List<int> encryptedIntList) {
  final encryptedBytes = Uint8List.fromList(encryptedIntList);

  final key = encrypt.Key.fromUtf8(_aesKey);
  final iv = encrypt.IV.fromUtf8(_aesIV);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  final decrypted =
      encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);
  return decrypted;
}

class DownloadedVideoList extends StatefulWidget {
  const DownloadedVideoList({super.key});

  @override
  State<DownloadedVideoList> createState() => _DownloadedVideoListState();
}

class _DownloadedVideoListState extends State<DownloadedVideoList> {
  final videoController = Get.put(VideoController());
  List<FileSystemEntity> videoFiles = [];
  Map<String, String?> thumbnailCache = {};
  Map<String, Map<String, String>> downloadedVideoMetadata = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloadedVideos();
  }
  

  Future<void> _loadDownloadedVideos() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync();
    final aesFiles = files.where((f) => f.path.endsWith('.aes')).toList();

    final prefs = await SharedPreferences.getInstance();
    final metadataMap = <String, Map<String, String>>{};

    for (var file in aesFiles) {
      final filename = file.path.split('/').last.replaceAll('.aes', '');
      final title = prefs.getString('$filename.title') ?? filename;
      final description = prefs.getString('$filename.description') ??
          'No description available';
      metadataMap[filename] = {
        'title': title,
        'description': description,
      };
    }

    setState(() {
      videoFiles = aesFiles;
      downloadedVideoMetadata = metadataMap;
      isLoading = false;
    });
  }

  Future<File> _decryptFile(File encryptedFile) async {
    final filename =
        encryptedFile.uri.pathSegments.last.replaceAll('.aes', '.mp4');
    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/$filename';
    final tempFile = File(tempFilePath);

    if (await tempFile.exists()) {
      return tempFile;
    }

    final encryptedBytes = await encryptedFile.readAsBytes();
    final decryptedBytes = await compute(aesDecrypt, encryptedBytes.toList());

    await tempFile.writeAsBytes(Uint8List.fromList(decryptedBytes));
    return tempFile;
  }


  Future<String?> _generateThumbnail(File encryptedFile) async {
    final pathKey = encryptedFile.path;
    if (thumbnailCache.containsKey(pathKey)) {
      return thumbnailCache[pathKey];
    }

    try {
      final decryptedFile = await _decryptFile(encryptedFile);

      final thumbnailDir = await getApplicationDocumentsDirectory();
      final thumbnailPath = '${thumbnailDir.path}/${pathKey.hashCode}.jpg';

      if (File(thumbnailPath).existsSync()) {
        thumbnailCache[pathKey] = thumbnailPath;
        return thumbnailPath;
      }

      final generated = await VideoThumbnail.thumbnailFile(
        video: decryptedFile.path,
        thumbnailPath: thumbnailPath,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 120,
        quality: 75,
      );

      thumbnailCache[pathKey] = generated;
      return generated;
    } catch (e) {
      debugPrint('Thumbnail generation failed: $e');
      return null;
    }
  }

  void _playDecryptedVideo(File encryptedFile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final decryptedFile = await _decryptFile(encryptedFile);
      if (!mounted) return;
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayerFullScreen(videoUrl: decryptedFile.path),
        ),
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to decrypt/play video: $e')),
        );
      }
    }
  }

  void _confirmDelete(File file) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Video'),
          content: Text(
            'Are you sure you want to delete "${file.path.split('/').last}"?',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await file.delete();
                _loadDownloadedVideos();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Video deleted')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded Videos', style: AppTextStyles.heading),
      ),
      body: isLoading
          ? const Shimmerload()
          : videoFiles.isEmpty
              ? Center(
                  child: Text('No downloaded videos found.',
                      style: AppTextStyles.subHeading.withColor(blackColor)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                  itemCount: videoFiles.length,
                  itemBuilder: (context, index) {
                    final file = videoFiles[index];
                    final filename = file.path.split('/').last;

                    final videoIndex = int.tryParse(
                        filename.replaceAll(RegExp(r'[^0-9]'), ''));

                    final video = (videoIndex != null &&
                            videoIndex >= 0 &&
                            videoIndex < videoController.videoList.length)
                        ? videoController.videoList[videoIndex]
                        : null;

                    final title = video?['title'] ?? 'NA';
                    final description =
                        video?['description'] ?? 'No description available';

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.r),
                      child: linecontainer(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _playDecryptedVideo(File(file.path)),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: FutureBuilder<String?>(
                                        future:
                                            _generateThumbnail(File(file.path)),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData &&
                                              snapshot.data != null) {
                                            return Image.file(
                                              File(snapshot.data!),
                                              fit: BoxFit.cover,
                                            );
                                          } else {
                                            return Container(
                                              color: Colors.grey[300],
                                              child: const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.play_circle_fill,
                                      size: 64.r, color: Colors.white70),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.r),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16.r,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.r),
                                  Text(
                                    description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.r,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            _confirmDelete(File(file.path)),
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// Future<File> _decryptPartialFile(File encryptedFile) async {
//   final filename =
//       encryptedFile.uri.pathSegments.last.replaceAll('.aes', '_preview.mp4');
//   final tempDir = await getTemporaryDirectory();
//   final tempFilePath = '${tempDir.path}/$filename';
//   final tempFile = File(tempFilePath);

//   if (await tempFile.exists()) return tempFile;

//   final encryptedBytes = await encryptedFile.readAsBytes();

//   // ⚠️ Estimate: Decrypt first ~12MB (2 minutes at average bitrate)
//   final int previewLength = 12 * 1024 * 1024; // 12MB
//   final partialBytes = encryptedBytes.take(previewLength).toList();

//   final decryptedBytes = await compute(aesDecrypt, partialBytes);
//   await tempFile.writeAsBytes(Uint8List.fromList(decryptedBytes));

//   return tempFile;
// }
