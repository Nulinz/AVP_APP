import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sakthiexports/Components/Formfield.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import '../../Controller/Logincontroller.dart';
import '../Screens/Homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Logincontroller logincontroller = Get.put(Logincontroller());

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
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
          body: Stack(
            children: [
              // Login Form
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
                            IconName: Icons.person),
                      ),
                      SizedBox(height: 18.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LRTextInput(
                          LabelText: 'Password',
                          Controller: logincontroller.passwordcontroller,
                          HintText: 'Password',
                          ValidatorText: 'Please Enter Password',
                          IconName: Icons.key,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => const CurriculumDashboard());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: const Text('Login'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: const Text(
                          'Version 1.2 © AVP Siddha Academy ',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.black87),
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

              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
