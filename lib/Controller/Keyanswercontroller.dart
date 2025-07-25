import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Backendservice/BackendService.dart';
import '../Backendservice/connectionService.dart';

class Keyanswercontroller extends GetxController {
  var isLoading = false.obs;
  var answers = <Map<String, dynamic>>[].obs;

  Future<void> fetchAnswers({required int examId}) async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final enrollmentNo = prefs.getString("enrollment_no");

      if (enrollmentNo == null) {
        answers.clear();
        return;
      }

      final response = await Backendservice.function(
        {
          "exam_id": examId,
          "enrollment_no": enrollmentNo,
          "button_type": "answers",
        },
        ConnectionService.questions,
        "POST",
      );

      if (response['status'] == 'success') {
        answers.value = List<Map<String, dynamic>>.from(response['answers']);
      } else {
        answers.clear();
      }
    } catch (e) {
      print("Error fetching answers: $e");
      answers.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
