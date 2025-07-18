// import 'package:get/get.dart';

// import '../Backendservice/BackendService.dart';
// import '../Backendservice/connectionService.dart';


// class KeyAnswerController extends GetxController {
//   final int empId;
//   final int curriculumId;

//   var isLoading = false.obs;
//   var answerList = <Map<String, dynamic>>[].obs;

//   KeyAnswerController(this.empId, this.curriculumId);

//   @override
//   void onInit() {
//     super.onInit();
//     fetchKeyAnswers();
//   }

//   Future<void> fetchKeyAnswers() async {
//     try {
//       isLoading.value = true;

//       final response = await Backendservice.function(
//         {},
//         "${ConnectionService.keyAnswer}?emp_id=$empId&curriculum_id=$curriculumId",
//         "GET",
//       );

//       if (response['success'] == true) {
//         final data = response['data'] ?? [];

//         answerList.value = List<Map<String, dynamic>>.from(data.map((item) => {
//               'question': item['question'],
//               'answer': item['answer'],
//               'userAnswer': item['user_answer'],
//             }));
//       } else {
//         answerList.clear();
//       }
//     } catch (e) {
//       print("Error fetching key answers: $e");
//       answerList.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
// }