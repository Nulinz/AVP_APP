// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../Backendservice/BackendService.dart';
// import '../Backendservice/ConnectionService.dart';

// class DashboardController extends GetxController {
//   var isLoading = false.obs;

//   var modelTestTitle = "".obs;
//   var modelTestDate = "".obs;
//   var modelTestPortion = "".obs;

//   var subjectSchedule = <Map<String, String>>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchDashboardData();
//   }

//   Future<void> fetchDashboardData() async {
//     try {
//       isLoading.value = true;

//        final response = await Backendservice.function(
//        {},
//       ConnectionService.Dashboard,
//        "GET",
//        );

//       if (response['success'] == true) {
//         final data = response['data'];

//         modelTestTitle.value = data['test_title'] ?? 'Model Test - N/A';
//         modelTestDate.value = data['test_date'] ?? '00.00.0000';
//         modelTestPortion.value = data['test_portion'] ?? 'No info available';

//         subjectSchedule.value =
//             List<Map<String, String>>.from(data['schedule'] ?? []);
//       } else {
//         modelTestTitle.value = "Model Test - N/A";
//         modelTestDate.value = "00.00.0000";
//         modelTestPortion.value = "No info available";
//         subjectSchedule.clear();
//       }
//     } catch (e) {
//       print("Dashboard fetch error: $e");
//       subjectSchedule.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

// DashboardController.dart

// import 'package:get/get.dart';
// import 'package:sakthiexports/Backendservice/BackendService.dart';
// import 'package:sakthiexports/Backendservice/ConnectionService.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DashboardController extends GetxController {
//   var isScheduleLoading = false.obs;
//   var scheduleSubjects = <Map<String, String>>[].obs;
//   var scheduleDate = ''.obs;

//   Future<void> fetchScheduleForToday() async {
//     try {
//       isScheduleLoading.value = true;

//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       String enrollmentNo = prefs.getString('enrollment_no') ?? '';
//       print("dash enroll :$enrollmentNo");

//       final response = await Backendservice.function(
//         {
//           "button_type": "schedule",
//           "enrollment_no": enrollmentNo,
//         },
//         ConnectionService.Dashboard3,
//         "POST",
//       );

//       if (response['status'] == "success") {
//         final List rawData = response['data'];
//         print("rawData in dash : $rawData");

//         if (rawData.isNotEmpty) {
//           String rawDate = rawData.first['expiry_date'] ?? '';
//           scheduleDate.value = rawDate.replaceAll('-', '.');
//         }

//         print("dash rawdata :${scheduleDate.value}");

//         scheduleSubjects.value = rawData.map<Map<String, String>>((item) {
//           return {
//             "subject": item['subject'] ?? '',
//             "videoTitle":item['video_title'] ?? '',
//             "description": item['description'] ?? '',
//           };
//         }).toList();
//       } else {
//         scheduleSubjects.clear();
//         scheduleDate.value = '';
//       }
//     } catch (e) {
//       print("Schedule fetch error: $e");
//       scheduleSubjects.clear();
//       scheduleDate.value = '';
//     } finally {
//       isScheduleLoading.value = false;
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:sakthiexports/Backendservice/BackendService.dart';
import 'package:sakthiexports/Backendservice/ConnectionService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  var isScheduleLoading = false.obs;
  var scheduleSubjects = <Map<String, String>>[].obs;
  var notificationList = <Map<String, String>>[].obs;
  var scheduleDate = ''.obs;
  var isNotificationLoading = false.obs;
  var lastExamTitle = ''.obs;
  var lastExamDate = ''.obs;
  var lastExamId = 0.obs;
  var hasLastExam = false.obs;
  var isLastExamLoading = false.obs;
  RxBool isLoading = false.obs;

  var enrollmentNo = "".obs;
  var lastExams = <Map<String, dynamic>>[].obs;
 
  // 👇 Add this new observable for notification

  Future<void> fetchScheduleForToday() async {
    try {
      isScheduleLoading.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String enrollmentNo = prefs.getString('enrollment_no') ?? '';
      print("dash enroll :$enrollmentNo");

      final response = await Backendservice.function(
        {
          "button_type": "schedule",
          "enrollment_no": enrollmentNo,
        },
        ConnectionService.Dashboard3,
        "POST",
      );

      if (response['status'] == "success") {
        final List rawData = response['data'];
        print("rawData in dash : $rawData");

        if (rawData.isNotEmpty) {
          String rawDate = rawData.first['expiry_date'] ?? '';
          scheduleDate.value = rawDate.replaceAll('-', '.');
        }

        print("dash rawdata :${scheduleDate.value}");

        scheduleSubjects.value = rawData.map<Map<String, String>>((item) {
          return {
            "subject": item['subject'] ?? '',
            "videoTitle": item['video_title'] ?? '',
            "description": item['description'] ?? '',
          };
        }).toList();
      } else {
        scheduleSubjects.clear();
        scheduleDate.value = '';
      }
    } catch (e) {
      print("Schedule fetch error: $e");
      scheduleSubjects.clear();
      scheduleDate.value = '';
    } finally {
      isScheduleLoading.value = false;
    }
  }

  /// 🔔 Function to fetch notification data from backend
  Future<List<Map<String, String>>> fetchNotificationData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String enrollmentNo = prefs.getString('enrollment_no') ?? '';

      final response = await Backendservice.function(
        {
          "enrollment_no": enrollmentNo,
          "button_type": "list_notify",
        },
        ConnectionService.notify,
        "POST",
      );

      print("API Response: $response");

      if (response["status"] == "success") {
        print("inside ressponse $response");
        final List data = response["notifications"];
        notificationList.value = data
            .map<Map<String, String>>((item) => {
                  "title": item["title"]?.toString() ?? '',
                  "description": item["description"]?.toString() ?? '',
                })
            .toList();
      } else {
        print("No notifications found.");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }

    return notificationList;
  }
void loadLastExam() async {
    isLastExamLoading.value = true;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String enrollmentNo = prefs.getString('enrollment_no') ?? '';

      final response = await Backendservice.function(
        {
          "button_type": "last_exam",
          "enrollment_no": enrollmentNo,
        },
        ConnectionService.checkresult,
        "POST",
      );
      print("response data $response");

      if (response['status'] == "success" && response['data'].isNotEmpty) {
        lastExams.assignAll(List<Map<String, dynamic>>.from(response['data']));
        hasLastExam.value = true;
      } else {
        hasLastExam.value = false;
        lastExams.clear();
      }
    } catch (e) {
      print("Error loading last exam: $e");
      hasLastExam.value = false;
      lastExams.clear();
    } finally {
      isLastExamLoading.value = false;
    }
  }


  var marqueeText = ''.obs;
  var isLoadingMarquee = false.obs;
  void loadMarqueeText() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String enrollmentNo = prefs.getString('enrollment_no') ?? '';

      final response = await Backendservice.function(
        {
          "button_type": "text_scroll",
          "enrollment_no": enrollmentNo,
        },
        ConnectionService.marquee,
        "POST",
      );

      print("Marquee Response: $response");

      if (response['status'] == "success" &&
          response['data'] != null &&
          response['data'].isNotEmpty) {
        marqueeText.value = response['data'][0]['scroll_text'] ?? '';
        print("marquee text: ${marqueeText.value}");
      } else {
        marqueeText.value = '';
      }
    } catch (e) {
      print("Error loading marquee text: $e");
      marqueeText.value = '';
    }
  }
}
