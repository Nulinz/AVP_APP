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
