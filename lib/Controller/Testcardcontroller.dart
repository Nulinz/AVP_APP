// import 'package:get/get.dart';
// import '../Backendservice/BackendService.dart';
// import '../Backendservice/connectionService.dart';

// class QuestionController extends GetxController {
//   final int empId;
//   final int curriculumId;

//   var isLoading = false.obs;
//   var isSubmitting = false.obs;

//   var questionList = <Map<String, dynamic>>[].obs;
//   var selectedAnswers = <int, String>{}.obs; // question_id → selected option

//   QuestionController(this.empId, this.curriculumId);

//   @override
//   void onInit() {
//     super.onInit();
//     fetchQuestions();
//   }

//   Future<void> fetchQuestions() async {
//     try {
//       isLoading.value = true;

//       final response = await Backendservice.function(
//         {},
//         "${ConnectionService.getQuestions}?emp_id=$empId&curriculum_id=$curriculumId",
//         "GET",
//       );

//       if (response['success'] == true) {
//         final data = response['data'] ?? [];

//         questionList.value = List<Map<String, dynamic>>.from(data);
//       } else {
//         questionList.clear();
//       }
//     } catch (e) {
//       print("Error fetching questions: $e");
//       questionList.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void selectAnswer(int questionId, String answer) {
//     selectedAnswers[questionId] = answer;
//   }

//   Future<void> submitAnswers() async {
//     try {
//       isSubmitting.value = true;

//       final answersPayload = selectedAnswers.entries
//           .map((entry) => {
//                 "question_id": entry.key,
//                 "selected_answer": entry.value,
//               })
//           .toList();

//       final body = {
//         "emp_id": empId,
//         "curriculum_id": curriculumId,
//         "answers": answersPayload,
//       };

//       final response = await Backendservice.function(
//         body,
//         ConnectionService.submitAnswers,
//         "POST",
//       );

//       if (response['success'] == true) {
//         Get.snackbar("Success", "Answers submitted successfully");
//       } else {
//         Get.snackbar("Error", "Failed to submit answers");
//       }
//     } catch (e) {
//       print("Submit error: $e");
//       Get.snackbar("Error", "Something went wrong");
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
// }
