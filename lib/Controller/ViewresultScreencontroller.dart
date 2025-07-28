import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Backendservice/BackendService.dart';
import '../Backendservice/connectionService.dart';

class ViewresultScreencontroller extends GetxController {
  var isLoading = false.obs;
  var summaryData = <Map<String, String>>[].obs;

  Future<void> fetchExamResult( {required int examId}) async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final enrollmentNo = prefs.getString("enrollment_no");

      if (enrollmentNo == null) {
        summaryData.clear();
        return;
      }

      final response = await Backendservice.function(
        {
          "exam_id": examId,
          "enrollment_no": enrollmentNo,
          "button_type": "result",
        },
        ConnectionService.questions,
        "POST",
      );

      print("Exam Result API Response: $response");

      if (response['status'] == 'success') {
        summaryData.value = [
          {"label": "S.NO", "value": "1"},
          {"label": "EXAM", "value": response['exam_name'] ?? "N/A"},
          {
            "label": "TOTAL Qns",
            "value": response['total_no_questions'].toString()
          },
          {"label": "NOT ANSWER", "value": response['not_answer'].toString()},
          {"label": "CORRECT", "value": response['correct'].toString()},
          {"label": "WRONG", "value": response['Wrong'].toString()},
          {"label": "MARKS", "value": response['marks'].toString()},
        ];
      } else {
        summaryData.clear();
      }
    } catch (e) {
      print("Error fetching exam result: $e");
      summaryData.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
