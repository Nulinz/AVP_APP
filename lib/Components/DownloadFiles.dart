// import 'package:flutter/material.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';

// import '../Theme/Colors.dart';

// class DownloadFile extends StatefulWidget {
//   final String url;

//   const DownloadFile({Key? key, required this.url}) : super(key: key);

//   @override
//   State<DownloadFile> createState() => _DownloadFileState();
// }

// class _DownloadFileState extends State<DownloadFile> {
//   final SessionSettings settings = SessionSettings();

//   @override
//   Widget build(BuildContext context) {
//     print("started");
//     return SizedBox(
//       child: InkWell(
//         onTap: () async {
//           FileDownloader.downloadFile(
//               url: "https://onstru.com/onstru/Mobile/img/shopping (1).webp",
//               downloadDestination: settings.downloadDestination,
//               notificationType: settings.notificationType,
//               onDownloadRequestIdReceived: (downloadId) {
//                 Get.snackbar(
//                     "Dowload Started", 'Please Check your Notification',
//                     colorText: Colors.black,
//                     icon: const Icon(FontAwesomeIcons.download),
//                     snackPosition: SnackPosition.TOP,
//                     backgroundColor: Colors.grey,
//                     backgroundGradient: const LinearGradient(
//                       colors: [
//                         kPrimaryColor,
//                         Color.fromARGB(255, 134, 207, 249)
//                       ],
//                     ));
//               },
//               onDownloadCompleted: (
//                 fileNamepath,
//               ) {
//                 Get.snackbar(
//                     "Download Sucessful", 'File downloaded to: $fileNamepath',
//                     icon: const Icon(
//                       FontAwesomeIcons.solidCircleCheck,
//                       size: 30,
//                     ),
//                     colorText: Colors.black,
//                     snackPosition: SnackPosition.TOP,
//                     backgroundColor: Colors.grey,
//                     backgroundGradient: const LinearGradient(
//                       colors: [
//                         kPrimaryColor,
//                         Color.fromARGB(255, 134, 207, 249)
//                       ],
//                     ));
//               },
//               onDownloadError: (error) {
//                 setState(() {
//                   Get.snackbar("Download Unsusscessful", '',
//                       icon: const Icon(FontAwesomeIcons.exclamation),
//                       colorText: Colors.black,
//                       snackPosition: SnackPosition.TOP,
//                       backgroundColor: Colors.grey,
//                       backgroundGradient: const LinearGradient(
//                         colors: [
//                           kPrimaryColor,
//                           Color.fromARGB(255, 134, 207, 249)
//                         ],
//                       ));
//                 });
//               });
//           //  }
//         },
//       ),
//     );
//   }
// }

// class SessionSettings {
//   static SessionSettings? _instance;
//   var _notificationType = NotificationType.all;
//   var _downloadDestination = DownloadDestinations.publicDownloads;
//   var _maximumParallelDownloads = FileDownloader().maximumParallelDownloads;

//   SessionSettings._();

//   factory SessionSettings() => _instance ??= SessionSettings._();

//   void setNotificationType(NotificationType notificationType) =>
//       _notificationType = NotificationType.all;

//   void setDownloadDestination(DownloadDestinations downloadDestination) =>
//       _downloadDestination = downloadDestination;

//   void setMaximumParallelDownloads(int maximumParallelDownloads) {
//     if (maximumParallelDownloads <= 0) return;
//     _maximumParallelDownloads = maximumParallelDownloads;
//     FileDownloader.setMaximumParallelDownloads(maximumParallelDownloads);
//   }

//   NotificationType get notificationType => _notificationType;

//   DownloadDestinations get downloadDestination => _downloadDestination;

//   int get maximumParallelDownloads => _maximumParallelDownloads;
// }
