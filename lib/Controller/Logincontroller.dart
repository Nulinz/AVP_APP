import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sakthiexports/Backendservice/BackendService.dart';
import 'package:sakthiexports/Backendservice/connectionService.dart';
import 'package:sakthiexports/Components/Snackbars.dart';
import 'package:sakthiexports/View/Screens/Homepage.dart';

class Logincontroller extends GetxController {
  final phonecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  var isLoading = false.obs;
  var deviceName = ''.obs;

  Future<void> loginUser() async {
    final enrollmentNo = phonecontroller.text.trim();
    final password = passwordcontroller.text.trim();

    if (enrollmentNo.isEmpty || password.isEmpty) {
      CustomSnackbar("Validation", "Please fill in all fields");
      return;
    }
    try {
      isLoading.value = true;

      final response = await Backendservice.Login({
        'button_type': 'login',
        'enrollment_no': enrollmentNo,
        'password': password,
        'device_name': deviceName.value,
      }, ConnectionService.login, "POST");

      print("Login Response: $response");

      if (response["message"] == "Login successfully") {
        if (response["device_name"] != deviceName.value) {
          CustomSnackbar(
              "Access Denied", "This account is registered to another device.");
          isLoading.value = false;
          return;
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("enrollment_no", response["enrollment_no"] ?? '');
        await prefs.setString("device_name", response["device_name"] ?? '');
        print("Longinpage enrollmentno: ${response["enrollment_no"]}");
        print("Loginpage devicename: ${response["device_name"]}");
        phonecontroller.clear();
        passwordcontroller.clear();
        CustomSnackbar("Success", "Login successful");
        Get.offAll(() => const CurriculumDashboard());
      } else {
        CustomSnackbar("Error", "Invalid enrollment number or password");
      }
    } catch (e) {
      print("Error Something went wrong during login : $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phonecontroller.dispose();
    passwordcontroller.dispose();
    super.onClose();
  }
}
