// // ignore_for_file: avoid_print, use_build_context_synchronously

// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:avpsiddhacademy/view/Dashboard/Notify.dart';
// // import 'package:sitesync/View/Screens/Notification.dart';

// class NotificationServices {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void initialize(BuildContext context) {
//     createNotificationChannel(); // Create the notification channel
//     firebaseInit(context); // Initialize Firebase messaging
//   }

//   void isRefreshToken() async {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//       print('TOken Refereshed');
//     });
//   }

//   Future<void> createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         '1', // Channel ID
//         'High Importance Notifications',
//         importance: Importance.high,
//         playSound: true,
//         sound: RawResourceAndroidNotificationSound('sound'));

//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   Future<void> requestStoragePermission() async {
//     PermissionStatus status = await Permission.storage.status;
//     if (!status.isGranted) {
//       // Request permission from the user
//       status = await Permission.storage.request();
//       if (status.isGranted) {
//         print("Granted");
//       } else {
//         print("not granted");
//       }
//     }
//   }

//   void backgroundMessageHandler(RemoteMessage message) {
//     print("Handling background message: ${message.messageId}");
//     if (message.notification != null) {
//       showNotification(message);
//     }
//   }

//   Future forgroundMessage() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//             alert: true, badge: true, sound: true);
//   }

//   void requestNotificationPermisions() async {
//     print("function called");
//     if (Platform.isAndroid) {
//       PermissionStatus status = await Permission.notification.status;
//       if (!status.isGranted) {
//         status = await Permission.notification.request();
//         if (status.isGranted) {
//           print("Notification permission granted");
//         } else {
//           print("Notification permission not granted");
//           showAlertDialognotification();
//         }
//       }
//     }
//     if (Platform.isIOS) {
//       NotificationSettings notificationSettings =
//           await messaging.requestPermission(
//               alert: true,
//               announcement: true,
//               badge: true,
//               carPlay: true,
//               criticalAlert: true,
//               provisional: false,
//               sound: true);

//       if (notificationSettings.authorizationStatus ==
//           AuthorizationStatus.authorized) {
//         print('user is already granted permisions');
//       } else if (notificationSettings.authorizationStatus ==
//           AuthorizationStatus.provisional) {
//         print('user is already granted provisional permisions');
//       } else {
//         print('User has denied permission');
//         showAlertDialognotification();
//       }
//     }
//   }

//   void showAlertDialognotification() {
//     Get.dialog(
//       CupertinoAlertDialog(
//         title: const Text('Permission Denied'),
//         content: const Text('Allow access to receive notification'),
//         actions: <CupertinoDialogAction>[
//           CupertinoDialogAction(
//             textStyle: GoogleFonts.poppins(
//                 textStyle: const TextStyle(
//               color: Colors.blue,
//               fontWeight: FontWeight.w600,
//             )),
//             onPressed: () => Get.back(), // Close the dialog
//             child: const Text(
//               'Cancel',
//             ),
//           ),
//           CupertinoDialogAction(
//             textStyle: GoogleFonts.poppins(
//                 textStyle: TextStyle(
//               color: Colors.blue,
//               fontWeight: FontWeight.w600,
//             )),
//             isDefaultAction: true,
//             onPressed: () => openAppSettings(),
//             child: const Text('Settings'),
//           ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//   }

//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? notification = message.notification;

//       createNotificationChannel();
//       print("Notification title: ${notification!.title}");
//       print("Notification title: ${notification.body}");
//       print("Data: ${message.data.toString()}");

//       // For IoS
//       if (Platform.isIOS) {
//         forgroundMessage();
//         showNotification(message);
//       }

//       if (Platform.isAndroid) {
//         initLocalNotifications(context, message);
//         showNotification(message);
//       }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       handleMesssage(context, message);
//     });
//   }

//   void initLocalNotifications(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitSettings = const DarwinInitializationSettings(
//       requestAlertPermission: true, // Request permission for alerts
//       requestBadgePermission: true, // Request permission for badges
//       requestSoundPermission: true,
//     );

//     var initSettings = InitializationSettings(
//         android: androidInitSettings, iOS: iosInitSettings);

//     await _flutterLocalNotificationsPlugin.initialize(initSettings,
//         onDidReceiveNotificationResponse: (payload) {
//       handleMesssage(context, message);
//     });
//     print("**************");
//   }

//   void handleMesssage(BuildContext context, RemoteMessage message) {
//     print('In handleMesssage function');
//     if (message.data['screen'] == 'notificationScreen') {
//       Get.to(() => Notify(roleid:  'roleid'));
//     } else {
//       Get.to(() => Notify(roleid:'roleid'));
//     }
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     print("**************");
//     AndroidNotificationDetails androidNotificationDetails =
//         const AndroidNotificationDetails(
//             'high_importance_channel', 'High Importance Notifications',
//             channelDescription: 'Flutter Notifications',
//             importance: Importance.high,
//             priority: Priority.high,
//             playSound: true,
//             ticker: 'ticker',
//             sound: RawResourceAndroidNotificationSound('sound'));

//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//             presentAlert: true, presentBadge: true, presentSound: true);

//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);

//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//           0,
//           message.notification!.title.toString(),
//           message.notification!.body.toString(),
//           notificationDetails);
//     });
//   }

//   Future<void> setupInteractMessage(BuildContext context) async {
//     // when app is terminated
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     if (initialMessage != null) {
//       handleMesssage(context, initialMessage);
//     }

//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMesssage(context, event);
//     });
//   }
// }
