// import 'package:get/get.dart';

// import '../Backendservice/BackendService.dart';
// import '../Backendservice/connectionService.dart';

// class QuestionPaperController extends GetxController {
//   final int empId;
//   final int curriculumId;

//   var isLoading = false.obs;
//   var questionList = <Map<String, dynamic>>[].obs;

//   QuestionPaperController(this.empId, this.curriculumId);

//   @override
//   void onInit() {
//     super.onInit();
//     fetchQuestionPaper();
//   }

//   Future<void> fetchQuestionPaper() async {
//     try {
//       isLoading.value = true;

//       final response = await Backendservice.function(
//         {},
//         "${ConnectionService.questionPaper}?emp_id=$empId&curriculum_id=$curriculumId",
//         "GET",
//       );

//       if (response['success'] == true) {
//         final data = response['data'] ?? [];
//         questionList.value = List<Map<String, dynamic>>.from(data);
//       } else {
//         questionList.clear();
//       }
//     } catch (e) {
//       print("Error fetching question paper: $e");
//       questionList.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
