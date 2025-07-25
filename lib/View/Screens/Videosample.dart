import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:sakthiexports/Theme/Fonts.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../Controller/Videocontroller.dart';
import 'VideoPlayerfullscreen.dart';

class SampleVideoListPlayer extends StatefulWidget {
  const SampleVideoListPlayer({super.key});

  @override
  State<SampleVideoListPlayer> createState() => _SampleVideoListPlayerState();
}

class _SampleVideoListPlayerState extends State<SampleVideoListPlayer> {
  final videoController = Get.put(VideoController());

  final Set<int> decryptedVideoIndices = {};

  late Future<void> _initialLoad;

  @override
  void initState() {
    super.initState();
    _initialLoad = _initControllerAndDownloads();
  }

  Future<void> _initControllerAndDownloads() async {
    await videoController.loadProfileFromPrefs(); // fetches list
    await _loadDownloadedVideos(); // loads local state
  }

  Future<void> _loadDownloadedVideos() async {
    final dir = await getApplicationDocumentsDirectory();

    for (int i = 0; i < videoController.videoList.length; i++) {
      final file = File('${dir.path}/video_$i.aes');
      if (await file.exists()) {
        decryptedVideoIndices.add(i);
      }
    }

    debugPrint("Restored download state: $decryptedVideoIndices");
    setState(() {});
  }

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
                        Navigator.of(dialogContext).pop();
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

  Future<bool> downloadAndEncryptVideo(BuildContext context, String url,
      String filename, int index, title, description) async {
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

      final prefs = await SharedPreferences.getInstance();
      final title = videoController.videoList[index]['title'] ?? '';
      final description = videoController.videoList[index]['description'] ?? '';

      await prefs.setString(
        filename,
        jsonEncode({'title': title, 'description': description}),
      );

      debugPrint("Metadata stored for $filename");

      setState(() {
        decryptedVideoIndices.add(index);
      });
      await Future.delayed(const Duration(milliseconds: 300));
      await _loadDownloadedVideos();

      return true;
    } catch (e) {
      Navigator.pop(context);
      debugPrint("Error during download or encryption: $e");
      return false;
    }
  }

  Future<File?> decryptToTempFile(String filename) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$filename.mp4');
      if (await tempFile.exists()) {
        return tempFile;
      }

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
        title: Text(
          "Course Videos",
          style: AppTextStyles.heading,
        ),
      ),
      body: Obx(() {
        if (videoController.isLoading.value) {
          return _buildShimmerList();
        }

        if (!videoController.isFetchCompleted.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (videoController.videoList.isEmpty) {
          return RefreshIndicator(
            onRefresh: videoController.fetchVideoList,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 350),
                Center(
                  child: Text(
                    "No Course Video Found",
                    style: AppTextStyles.subHeading.withColor(blackColor),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await videoController.fetchVideoList();
          },
          child: Obx(
            () => ListView.builder(
              itemCount: videoController.videoList.length,
              itemBuilder: (context, index) {
                final video = videoController.videoList[index];
                final url = video['url'];
                final title = video['title'];
                final filename = 'video_$index';
                final isDownloaded = decryptedVideoIndices.contains(index);
                final description =
                    video['description'] ?? 'No description available';
                final expiryDate = video['expiry_date'] ?? 'N/A';

                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.r),
                  child: linecontainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (isDownloaded) {
                              _openFullScreen(context, url, index);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please download the video first.")),
                              );
                            }
                          },
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
                                          future:
                                              _getVideoThumbnail(url, index),
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
                                                      CircularProgressIndicator(),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 2,
                                      style: AppTextStyles.subHeading
                                          .withColor(blackColor),
                                    ),
                                    SizedBox(height: 4.r),
                                    Text(
                                      description,
                                      maxLines: 2,
                                      style: AppTextStyles.body
                                          .withColor(blackColor),
                                    ),
                                    SizedBox(height: 2.r),
                                    FutureBuilder<String>(
                                      future: _getRemoteFileSize(url),
                                      builder: (context, snapshot) {
                                        return Text(
                                          snapshot.hasData
                                              ? "Size: ${snapshot.data}"
                                              : "Size: Loading...",
                                          style: AppTextStyles.small
                                              .withColor(greyColor),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 2.r),
                                    Text(
                                      "Expires on: $expiryDate",
                                      style: AppTextStyles.small
                                          .withColor(Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  if (isDownloaded) ...[
                                    SizedBox(
                                      width: Get.width / 4.5,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        onPressed: () => _openFullScreen(
                                            context, url, index),
                                        icon: const Icon(Icons.play_arrow),
                                        label: const Text("Play"),
                                      ),
                                    ),
                                    SizedBox(height: 4.r),
                                  ],
                                  IconButton(
                                    tooltip: "Download",
                                    icon: const Icon(Icons.download,
                                        color: kPrimaryColor),
                                    onPressed: () async {
                                      final success =
                                          await downloadAndEncryptVideo(
                                              context,
                                              url,
                                              filename,
                                              index,
                                              title,
                                              description);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            success
                                                ? 'Download complete!'
                                                : 'Download failed.',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
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
          ),
        );
      }),
    );
  }
}

Widget _buildShimmerList() {
  return ListView.builder(
    itemCount: 4,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: linecontainer(
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  height: 14,
                  width: Get.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Button shimmer (Download / Play)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 36,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
