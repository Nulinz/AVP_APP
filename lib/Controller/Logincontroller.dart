import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avpsiddhacademy/Backendservice/BackendService.dart';
import 'package:avpsiddhacademy/Backendservice/connectionService.dart';
import 'package:avpsiddhacademy/Components/Snackbars.dart';
import 'package:avpsiddhacademy/View/Screens/Homepage.dart';

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

      if (response["message"] == "Login successfully" &&
          (response["enrollment_no"] ?? '').isNotEmpty) {
        if (response["device_name"] != deviceName.value) {
          CustomSnackbar(
              "Access Denied", "This account is registered to another device.");
          isLoading.value = false;
          return;
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("enrollment_no", response["enrollment_no"] ?? '');
        await prefs.setString("device_name", response["device_name"] ?? '');
        await prefs.setString("student_name", response["student_name"] ?? '');
        await prefs.setString("batch_name", response["batch_name"] ?? '');

        print("Longinpage enrollmentno: ${response["enrollment_no"]}");
        print("Loginpage devicename: ${response["device_name"]}");
        print("Loginpage studentName: ${response["student_name"]}");
        print("Loginpage batchname: ${response["batch_name"]}");
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
