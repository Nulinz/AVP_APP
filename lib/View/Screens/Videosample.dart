import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:dio/dio.dart' as dio;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'VideoPlayerfullscreen.dart';

class SampleVideoListPlayer extends StatefulWidget {
  const SampleVideoListPlayer({super.key});

  @override
  State<SampleVideoListPlayer> createState() => _SampleVideoListPlayerState();
}

class _SampleVideoListPlayerState extends State<SampleVideoListPlayer> {
  final List<String> videoUrls = [
    'https://samplelib.com/lib/preview/mp4/sample-30s.mp4',
    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
    'https://samplelib.com/lib/preview/mp4/sample-10s.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    'https://samplelib.com/lib/preview/mp4/sample-5s.mp4'
  ];

  final Set<int> decryptedVideoIndices = {};

  Future<String> _getRemoteFileSize(String url) async {
    try {
      final response = await dio.Dio().head(url);
      final contentLength = response.headers.value('content-length');
      if (contentLength != null) {
        final bytes = int.tryParse(contentLength) ?? 0;
        if (bytes <= 0) return 'Unknown size';
        final kb = bytes / 1024;
        final mb = kb / 1024;
        return mb >= 1
            ? '${mb.toStringAsFixed(2)} MB'
            : '${kb.toStringAsFixed(2)} KB';
      } else {
        return 'Unknown size';
      }
    } catch (e) {
      debugPrint("HEAD request failed: $e");
      return 'Unknown size';
    }
  }

  Future<String?> _getVideoThumbnail(String url, int index) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempVideoPath = '${tempDir.path}/temp_video_$index.mp4';
      final tempVideoFile = File(tempVideoPath);

      // Download only if file doesn't exist
      if (!await tempVideoFile.exists()) {
        final response = await dio.Dio().get<List<int>>(
          url,
          options: dio.Options(responseType: dio.ResponseType.bytes),
        );
        await tempVideoFile.writeAsBytes(response.data!);
      }

      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: tempVideoFile.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 120,
        quality: 75,
      );

      return thumbnailPath;
    } catch (e) {
      debugPrint('Thumbnail generation failed: $e');
      return null;
    }
  }

  Future<void> showDownloadProgressDialog(
    BuildContext context,
    ValueNotifier<double> progress,
    ValueNotifier<int> totalBytes,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.only(left: 16, right: 8, top: 8),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Downloading..."),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      final shouldCancel = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Cancel Download"),
                            content: const Text(
                              "Are you sure you want to cancel the download?",
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text("Continue"),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldCancel == true) {
                        Navigator.of(dialogContext).pop(); // closes main dialog
                      }
                    },
                  ),
                ],
              ),
              content: ValueListenableBuilder<double>(
                valueListenable: progress,
                builder: (context, value, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearProgressIndicator(value: value),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<int>(
                        valueListenable: totalBytes,
                        builder: (context, bytes, _) {
                          final kb = (bytes / 1024).toStringAsFixed(2);
                          final mb = (bytes / (1024 * 1024)).toStringAsFixed(2);
                          return Text("Downloaded: $kb KB ($mb MB)");
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> downloadAndEncryptVideo(
      BuildContext context, String url, String filename, int index) async {
    try {
      ValueNotifier<double> progress = ValueNotifier(0.0);
      ValueNotifier<int> totalBytes = ValueNotifier(0);
      await showDownloadProgressDialog(context, progress, totalBytes);

      final response = await dio.Dio().get<List<int>>(
        url,
        options: dio.Options(responseType: dio.ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = received / total;
            totalBytes.value = received;
          }
        },
      );

      Navigator.pop(context);

      if (response.data == null) throw Exception("No data received");

      final key = encrypt.Key.fromUtf8('32charslongencryptionkey12345678');
      final iv = encrypt.IV.fromUtf8('1234567890abcdef');
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      final encrypted = encrypter.encryptBytes(response.data!, iv: iv);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename.aes');
      await file.writeAsBytes(encrypted.bytes);

      debugPrint("Downloaded and encrypted: ${file.path}");
      setState(() {
        decryptedVideoIndices.add(index);
      });

      return true;
    } catch (e) {
      Navigator.pop(context);
      debugPrint("Error during download or encryption: $e");
      return false;
    }
  }

  Future<File?> decryptToTempFile(String filename) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final encFile = File('${dir.path}/$filename.aes');
      if (!await encFile.exists()) return null;

      final encryptedBytes = await encFile.readAsBytes();
      final key = encrypt.Key.fromUtf8('32charslongencryptionkey12345678');
      final iv = encrypt.IV.fromUtf8('1234567890abcdef');
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      final decrypted =
          encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$filename.mp4');
      await tempFile.writeAsBytes(decrypted);
      return tempFile;
    } catch (e) {
      debugPrint("Decryption failed: $e");
      return null;
    }
  }

  void _openFullScreen(BuildContext context, String url, int index) async {
    final filename = 'video_$index';
    final dir = await getApplicationDocumentsDirectory();
    final encryptedFile = File('${dir.path}/$filename.aes');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (await encryptedFile.exists()) {
        final decryptedFile = await decryptToTempFile(filename);
        Navigator.pop(context);

        if (decryptedFile == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to decrypt video')),
          );
          return;
        }

        final exists = await decryptedFile.exists();
        final size = await decryptedFile.length();
        debugPrint("Decrypted file path: ${decryptedFile.path}");
        debugPrint("Decrypted file size: $size");

        if (!exists || size < 100 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Invalid or corrupted decrypted video")),
          );
          return;
        }

        setState(() {
          decryptedVideoIndices.add(index);
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerFullScreen(videoUrl: decryptedFile.path),
          ),
        );
      } else {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerFullScreen(videoUrl: url),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      debugPrint("Playback error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to play video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Videos"),
      ),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          final url = videoUrls[index];
          final filename = 'video_$index';
          final isDownloaded = decryptedVideoIndices.contains(index);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.r),
            child: linecontainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _openFullScreen(context, url, index),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: isDownloaded
                                ? Container(
                                    color: Colors.black12,
                                    child: const Center(
                                      child: Icon(Icons.check_circle,
                                          size: 48, color: Colors.green),
                                    ),
                                  )
                                : FutureBuilder<String?>(
                                    future: _getVideoThumbnail(url, index),
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
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                          ),
                        ),
                        const Icon(Icons.play_circle_fill,
                            size: 64, color: Colors.white70),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      "Video ${index + 1}",
                      style: TextStyle(
                        fontSize: 18.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    child: FutureBuilder<String>(
                      future: _getRemoteFileSize(url),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.hasData
                              ? "Size: ${snapshot.data}"
                              : "Size: Loading...",
                          style: TextStyle(
                            fontSize: 14.r,
                            color: Colors.grey.shade700,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8.r),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: Get.width / 4.5,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r)),
                            ),
                            onPressed: () =>
                                _openFullScreen(context, url, index),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text("Play"),
                          ),
                        ),
                        SizedBox(width: 8.r),
                        IconButton(
                          tooltip: "Download",
                          icon:
                              const Icon(Icons.download, color: kPrimaryColor),
                          onPressed: () async {
                            final success = await downloadAndEncryptVideo(
                                context, url, filename, index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(success
                                    ? 'Download complete!'
                                    : 'Download failed.'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.r),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
