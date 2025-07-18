// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../Components/UpdatePopup.dart';
// import '../Components/errorscreen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     appupdate();
//   }

//   void appupdate() async {
//     print("check app update function called");
//     try {
//       final response = await http.post(
//         Uri.parse(ConnectionService.update_popup),
//         body: {},
//       ).timeout(Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         print(jsonData['version']);
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         if (jsonData['version'] != '0.0.9') {
//           print("version not updated");
//           await prefs.remove('user_id');
//           await prefs.remove('user_name');
//           await prefs.remove('mobile_number');
//           await prefs.remove('image_url');
//           await prefs.remove('payment_status');
//           Get.offAll(() => const Updatepopup());
//         } else {
//           print("version updated");
//           checkLoginStatus();
//         }
//       } else {
//         print('${response.statusCode}');
//         Get.offAll(() =>
//             ErrorScreen(errorMessage: 'Server error: ${response.statusCode}'));
//       }
//     } catch (e) {
//       print(e);
//       Get.offAll(() => ErrorScreen(errorMessage: 'An error occurred: $e'));
//     }
//   }

//   Future<void> checkLoginStatus() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     var userId = prefs.getInt('user_id');
//     var paymentStatus = prefs.getString('payment_status');

//     print('splashScreen User Id: $userId');
//     print('splashScreen Payment Status: $paymentStatus');

//     if (userId != null &&
//         paymentStatus != null &&
//         paymentStatus.isNotEmpty &&
//         paymentStatus == 'success') {
//       Get.to(() => Dashboard(
//             isfirstTime: true,
//             gotoindex0: true,
//             gotoindex1: false,
//             gotoindex2: false,
//             gotoindex3: false,
//           ));
//     } else {
//       Get.to(() => LoginScreen());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.white,
//     );
//   }
// }
