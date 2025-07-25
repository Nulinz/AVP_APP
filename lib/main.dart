import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screen_protector/screen_protector.dart';
import 'Theme/appTheme.dart';
import 'View/Screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenProtector.preventScreenshotOn();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(context),
          home: AnimatedSplashScreen(
            splash: Image.asset('assets/images/logo.png'),
            splashIconSize: 200,
            nextScreen: const SplashScreen(),
            splashTransition: SplashTransition.fadeTransition,
            animationDuration: const Duration(seconds: 2),
          ),
          // Uncomment and configure these if you use named routes
          // initialRoute: AppRoutes.splashScreen,
          // getPages: AppRoutes.getPages,
          // unknownRoute: AppRoutes.unknown,
        );
      },
    );
  }
}
