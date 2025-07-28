import 'dart:async';

import 'package:get/get.dart';
import 'package:sakthiexports/Components/Snackbars.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Backendservice/BackendService.dart';
import '../Backendservice/connectionService.dart';

class Testcardcontroller extends GetxController {
  final int examId;
  var isLoading = false.obs;
  var questions = <Map<String, dynamic>>[].obs;
  RxMap<String, String> selectedOptions = <String, String>{}.obs;

  var selectedAnswers = <String, String>{}.obs;
  // key: quest_id, value: selected option

  Testcardcontroller({required this.examId});

  RxString subject = ''.obs;
  RxInt examDuration = 0.obs;
  RxString errorMessage = ''.obs;
  RxInt remainingSeconds = 0.obs;
  RxBool isSubmitted = false.obs;
  RxBool isUpdating = false.obs;

  Timer? timer;

  @override
  void onInit() {
    fetchQuestions();
    super.onInit();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final storedEnrollmentNo = prefs.getString('enrollment_no') ?? '';

      final requestData = {
        "exam_id": examId,
        "enrollment_no": storedEnrollmentNo,
        "button_type": "get_questions",
      };

      print("Sending request: $requestData");

      final response = await Backendservice.function(
        requestData,
        ConnectionService.examtime,
        "POST",
      );
      print("RESPONSES : $response");
      print("RESPONSES DATA : ${response['data']}");

      if (response['status'] == 'success') {
        questions.value = List<Map<String, dynamic>>.from(response['data']);
        subject.value = response['subject'] ?? '';
        examDuration.value =
            int.tryParse(response['exam_duration'].toString()) ?? 0;

        remainingSeconds.value = examDuration.value * 60;
        startTimer();
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

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        handleSubmit();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  void handleSubmit() async {
    if (isSubmitted.value) return;
    timer?.cancel();

    final prefs = await SharedPreferences.getInstance();
    final storedEnrollmentNo = prefs.getString('enrollment_no') ?? '';

    final payload = {
      "button_type": "submit_answers",
      "exam_id": examId.toString(),
      "enrollment_no": storedEnrollmentNo,
      "answers": selectedAnswers.entries.map((e) {
        return {
          "quest_id": e.key.toString(),
          "answer": e.value.toString(),
        };
      }).toList(),
    };

    print("PAYLOAD : $payload");

    try {
      isUpdating.value = true;

      final response = await Backendservice.functionMethod(
        payload,
        ConnectionService.submit,
        "POST",
      );

      print("RESPONSE : $response");

      if (response['status'] == 'success') {
        isSubmitted(true);
        CustomSnackbar("Success", "Answers submitted successfully");
      } else {
        // Get.snackbar("Error", response['message'] ?? "Submission failed");
        CustomErrorSnackbar();
      }
    } catch (e) {
      print("Submit error: $e");
      //  Get.snackbar("Error", "Something went wrong during submission");
      CustomErrorSnackbar();
    } finally {
      isUpdating.value = false;
    }
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }
}
