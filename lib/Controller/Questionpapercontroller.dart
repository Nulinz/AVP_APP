import 'package:get/get.dart';
import '../Backendservice/BackendService.dart';
import '../Backendservice/connectionService.dart';

class Questionpapercontroller extends GetxController {
  var isLoading = false.obs;
  var questions = <Map<String, dynamic>>[].obs;

  Future<void> fetchQuestions({required int examId}) async {
    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {
          "exam_id": examId,
          "button_type": "questions",
        },
        ConnectionService.questions,
        "POST",
      );

      if (response['status'] == 'success') {
        questions.value = List<Map<String, dynamic>>.from(response['data']);
      } else {
        questions.clear();
      }
    } catch (e) {
      print("Error fetching questions: $e");
      questions.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
