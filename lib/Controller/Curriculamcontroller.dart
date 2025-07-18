// import 'package:get/get.dart';

// import '../Backendservice/BackendService.dart';
// import '../Backendservice/connectionService.dart';
// class CurriculumController extends GetxController {
//   final int empId;
//   final int curriculumId;

//   var isLoading = false.obs;
//   var summaryData = <Map<String, String>>[].obs;

//   CurriculumController(this.empId, this.curriculumId);

//   @override
//   void onInit() {
//     super.onInit();
//     fetchCurriculumSummary();
//   }

//   Future<void> fetchCurriculumSummary() async {
//     try {
//       isLoading.value = true;

//       final response = await Backendservice.function(
//         {},
//         "${ConnectionService.curriculumSummary}?emp_id=$empId&curriculum_id=$curriculumId",
//         "GET",
//       );

//       if (response['success'] == true) {
//         final data = response['data'];

//         summaryData.value = [
//           {"label": "S.NO", "value": "1"},
//           {"label": "EXAM", "value": data['exam_name'] ?? "NA"},
//           {"label": "TOTAL Qns", "value": "${data['total_qns'] ?? '0'}"},
//           {"label": "NOT ANSWER", "value": "${data['not_answered'] ?? '0'}"},
//           {"label": "CORRECT", "value": "${data['correct'] ?? '0'}"},
//           {"label": "WRONG", "value": "${data['wrong'] ?? '0'}"},
//           {"label": "MARKS", "value": "${data['marks'] ?? '0'}"},
//         ];
//       } else {
//         summaryData.clear();
//       }
//     } catch (e) {
//       print("Error fetching curriculum summary: $e");
//       summaryData.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
