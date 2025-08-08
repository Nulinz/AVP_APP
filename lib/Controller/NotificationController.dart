import 'package:get/get.dart';
import 'package:avpsiddhacademy/Backendservice/BackendService.dart';
import 'package:avpsiddhacademy/Backendservice/connectionService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  var notifications = <Map<String, String>>[].obs;

  var enrollmentNo = "".obs;

  Future<void> fetchNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    enrollmentNo.value = prefs.getString('enrollment_no') ?? '';

    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {
          "enrollment_no": enrollmentNo.value,
          "button_type": "notify_fetch",
        },
        ConnectionService.notification,
        "POST",
      );

      if (response["status"] == "success") {
        final List data = response["notifications"];
        notifications.value = data
            .map((item) => {
                  "title": item["title"]?.toString() ?? '',
                  "description": item["description"]?.toString() ?? '',
                })
            .toList();
      } else {
        notifications.clear();
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
