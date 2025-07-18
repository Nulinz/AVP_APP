// ignore_for_file: avoid_print

import 'package:flutter/services.dart';

class NavigationChannel {
  static const MethodChannel _channel =
      MethodChannel('com.rootments.app/service_class/navigation');

  static Future<void> navigateToScreen(String screen) async {
    try {
      await _channel.invokeMethod('navigateToScreen', {"screen": screen});
    } on PlatformException catch (e) {
      print("Failed to navigate: '${e.message}'.");
    }
  }
}
