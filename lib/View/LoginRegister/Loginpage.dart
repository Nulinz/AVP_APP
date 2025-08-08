import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:avpsiddhacademy/Components/Formfield.dart';
import 'package:avpsiddhacademy/Theme/Colors.dart';
import '../../Controller/Logincontroller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Logincontroller logincontroller = Get.put(Logincontroller());
  final RxBool isPasswordHidden = true.obs;

  @override
  void initState() {
    super.initState();
    getDeviceName();
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

    logincontroller.deviceName.value = name;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Obx(
            () => Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Image.asset(
                          'assets/images/logo.png',
                          height: 200.h,
                        ),
                        const SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LRTextInput(
                            LabelText: 'Enrollment No',
                            Controller: logincontroller.phonecontroller,
                            HintText: 'Enter Number',
                            ValidatorText: 'Please Enter Enrollment No',
                            IconName: Icons.person,
                            obscureText: false,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Obx(
                            () => LRTextInput(
                              LabelText: 'Password',
                              Controller: logincontroller.passwordcontroller,
                              HintText: 'Password',
                              ValidatorText: 'Please Enter Password',
                              IconName: Icons.key,
                              obscureText: isPasswordHidden.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordHidden.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  isPasswordHidden.toggle();
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: logincontroller.isLoading.value
                                  ? null
                                  : () {
                                      if (logincontroller.phonecontroller.text
                                          .trim()
                                          .isEmpty) {
                                        Get.snackbar("Validation",
                                            "Please enter Enrollment No");
                                        return;
                                      }
                                      if (logincontroller
                                          .passwordcontroller.text
                                          .trim()
                                          .isEmpty) {
                                        Get.snackbar("Validation",
                                            "Please enter Password");
                                        return;
                                      }
                                      logincontroller.loginUser();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: logincontroller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text('Login'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: const Text(
                            'Version 1.2 © AVP Siddha Academy ',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                        const Text(
                          'Powered by Nulinz Education (P) Ltd',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 8, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                if (logincontroller.isLoading.value)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
