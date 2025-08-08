import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avpsiddhacademy/View/LoginRegister/Loginpage.dart';
import 'package:avpsiddhacademy/View/Screens/Homepage.dart';
import 'package:avpsiddhacademy/View/util/AccessDenied.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../Backendservice/BackendService.dart';
import '../../Backendservice/ConnectionService.dart';
import '../../Components/UpdatePopup.dart';
import '../../Components/errorscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var localdeviceName = '';
  @override
  void initState() {
    super.initState();
    getDeviceName();
    appupdate();
    // checkLoginStatus();
  }

  void appupdate() async {
    printSharedPreferences();
    print("Checking app update...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final enrollmentNo = prefs.getString('enrollment_no');
    print(enrollmentNo);
    try {
      final response = await Backendservice.function(
        {
          'button_type': 'popup',
          'enrollment_no': enrollmentNo?.toString() ?? ''
        },
        ConnectionService.update_popup,
        "POST",
      );
      print(response);

      if (response['version'] != null) {
        print("Version from server: ${response['version']}");

        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (response['version'] != '2.0.0') {
          print("Version outdated. Redirecting to Update screen.");
          await prefs.remove('enrollment_no');
          Get.offAll(() => const Updatepopup());
        } else if (response['device_name'] == null) {
          Get.offAll(() => const LoginPage());
        } else if (response['device_name'] != localdeviceName) {
          print(response['device_name']);
          print(localdeviceName);
          await prefs.remove('enrollment_no');
          Get.offAll(() => const AccessDeniedScreen());
        } else {
          print("App version is up to date.");
          print("App Running on Same Device");
          checkLoginStatus();
        }
      } else {
        Get.offAll(() => const LoginPage());
      }
    } catch (e) {
      Get.offAll(() => ErrorScreen(errorMessage: 'An error occurred: $e'));
    }
  }

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final enrollmentNo = prefs.getString('enrollment_no');

    print("Splash - Enrollment No: $enrollmentNo");

    if (enrollmentNo != null && enrollmentNo.isNotEmpty) {
      Get.offAll(() => const CurriculumDashboard());
    } else {
      Get.offAll(() => const LoginPage());
    }
  }

  Future<void> getDeviceName() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String name = '';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      name = '${androidInfo.manufacturer} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      name = '${iosInfo.name} ${iosInfo.model}';
    }

    localdeviceName = name;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
