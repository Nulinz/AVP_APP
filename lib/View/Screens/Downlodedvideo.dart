import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:video_thumbnail/video_thumbnail.dart';

import '../util/linecontainer.dart';
import 'VideoPlayerfullscreen.dart';

class DownloadedVideoList extends StatefulWidget {
  const DownloadedVideoList({super.key});

  @override
  State<DownloadedVideoList> createState() => _DownloadedVideoListState();
}

class _DownloadedVideoListState extends State<DownloadedVideoList> {
  List<FileSystemEntity> videoFiles = [];
  Map<String, String?> thumbnailCache = {};

  @override
  void initState() {
    super.initState();
    _loadDownloadedVideos();
  }

  Future<void> _loadDownloadedVideos() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync();
    final aesFiles = files.where((f) => f.path.endsWith('.aes')).toList();
    setState(() {
      videoFiles = aesFiles;
    });
  }

  Future<String?> _generateThumbnail(File encryptedFile) async {
    final pathKey = encryptedFile.path;
    if (thumbnailCache.containsKey(pathKey)) {
      return thumbnailCache[pathKey];
    }

    try {
      final decryptedFile =
          await decryptVideoInIsolate({'path': encryptedFile.path});

      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: decryptedFile.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 120,
        quality: 75,
      );

      thumbnailCache[pathKey] = thumbnailPath;
      return thumbnailPath;
    } catch (e) {
      debugPrint('Thumbnail generation failed: $e');
      return null;
    }
  }

  Future<File> decryptToTempFile(File encryptedFile) async {
    try {
      final encryptedBytes = await encryptedFile.readAsBytes();

      final key = encrypt.Key.fromUtf8('32charslongencryptionkey12345678');
      final iv = encrypt.IV.fromUtf8('1234567890abcdef');

      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final decrypted =
          encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

      final tempDir = await getTemporaryDirectory();
      final filename =
          encryptedFile.uri.pathSegments.last.replaceAll('.aes', '.mp4');
      final tempFile = File('${tempDir.path}/$filename');
      await tempFile.writeAsBytes(decrypted);

      return tempFile;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to decrypt video: $e')),
      );
      rethrow;
    }
  }

  void _playDecryptedVideo(File encryptedFile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final decryptedFile = await decryptToTempFile(encryptedFile);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayerFullScreen(videoUrl: decryptedFile.path),
        ),
      );
    } catch (_) {
      Navigator.pop(context);
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await file.delete();
                _loadDownloadedVideos();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Video deleted')),
                );
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
      appBar: AppBar(title: const Text('Downloaded Videos')),
      body: videoFiles.isEmpty
          ? const Center(child: Text('No downloaded videos found.'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              itemCount: videoFiles.length,
              itemBuilder: (context, index) {
                final file = videoFiles[index];
                final filename =
                    file.path.split('/').last.replaceAll('.aes', '');

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
                                    future: _generateThumbnail(File(file.path)),
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
                              Icon(
                                Icons.play_circle_fill,
                                size: 64.r,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.r),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.r),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  filename,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.r,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _confirmDelete(File(file.path)),
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
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

  Future<File> decryptVideoInIsolate(Map<String, dynamic> args) async {
    final encryptedPath = args['path'] as String;
    final encryptedBytes = await File(encryptedPath).readAsBytes();

    final key = encrypt.Key.fromUtf8('32charslongencryptionkey12345678');
    final iv = encrypt.IV.fromUtf8('1234567890abcdef');

    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final decryptedBytes =
        encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

    final tempDir = await getTemporaryDirectory();
    final filename = encryptedPath.split('/').last.replaceAll('.aes', '.mp4');
    final tempPath = '${tempDir.path}/$filename';

    final decryptedFile = File(tempPath);
    await decryptedFile.writeAsBytes(decryptedBytes);

    return decryptedFile;
  }
}
