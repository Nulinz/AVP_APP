// import 'package:get/get.dart';
// import '../Backendservice/BackendService.dart';
// import '../Backendservice/connectionService.dart';

// class TestController extends GetxController {
//   var isSubmitting = false.obs;

//   Future<void> submitAnswers({
//     required String examId,
//     required String enrollmentNo,
//     required List<Map<String, String>> answers,
//   }) async {
//     try {
//       isSubmitting.value = true;

//       final response = await Backendservice.function(
//         {
//           "button_type": "submit_answers",
//           "exam_id": examId,
//           "enrollment_no": enrollmentNo,
//           "answers": answers,
//         },
//         ConnectionService.examstart,
//         "POST",
//       );

//       if (response['status'] == 'success') {
//         Get.snackbar("Success", "Answers submitted successfully");
//       } else {
//         Get.snackbar("Error", response['message'] ?? "Submission failed");
//       }
//     } catch (e) {
//       print("Submit error: $e");
//       Get.snackbar("Error", "Something went wrong");
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
// }
