import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Logincontroller extends GetxController {
  final phonecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  var isLoading = false.obs;

  void loginUser() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    if (phonecontroller.text == '1234567890' &&
        passwordcontroller.text == 'password') {
      isLoading.value = false;

      Get.snackbar(
        "Success",
        "Login successful",
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );


    } else {
      isLoading.value = false;

      Get.snackbar(
        "Error",
        "Invalid credentials",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    phonecontroller.dispose();
    passwordcontroller.dispose();
    super.onClose();
  }
}
