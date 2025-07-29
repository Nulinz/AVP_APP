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

import 'package:get/get.dart';
import 'package:sakthiexports/Backendservice/BackendService.dart';
import 'package:sakthiexports/Backendservice/ConnectionService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  var isScheduleLoading = false.obs;
  var scheduleSubjects = <Map<String, String>>[].obs;
  var scheduleDate = ''.obs;

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
            "videoTitle":item['video_title'] ?? '',
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
}
