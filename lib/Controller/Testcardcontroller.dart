import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Backendservice/ConnectionService.dart';
import '../../Backendservice/BackendService.dart';

class TestController extends GetxController {
  RxList<Map<String, dynamic>> questions = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;
  RxString subject = ''.obs;
  RxInt examDuration = 0.obs;
  RxString errorMessage = ''.obs;

  final Map<int, String> selectedOptions = {};

  Timer? timer;
  RxInt remainingSeconds = 0.obs;
  RxBool isSubmitted = false.obs;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        handleSubmit();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  Future<void> fetchQuestions({required String examId}) async {
    try {
      isLoading(true);
      final response = await Backendservice.function(
        {
          "button_type": "get_questions",
          "exam_id": examId,
        },
        ConnectionService.examtime,
        "POST",
      );

      if (response['status'] == "success") {
        subject.value = response['subject'];
        examDuration.value =
            int.tryParse(response['exam_duration'].toString()) ?? 30;
        remainingSeconds.value = examDuration.value * 60;

        final List<dynamic> rawQuestions = response['data'];
        questions.value = rawQuestions.map((q) {
          return {
            'question': q['question_name'],
            'options': [
              q['option1'],
              q['option2'],
              q['option3'],
              q['option4'],
            ],
          };
        }).toList();

        startTimer();
      } else {
        errorMessage.value = 'Something went wrong.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load questions';
    } finally {
      isLoading(false);
    }
  }

  void handleSubmit({String? message}) {
    if (isSubmitted.value) return;
    timer?.cancel();
    isSubmitted(true);
    Get.snackbar(
      "Test Submitted",
      message ?? "Your answers have been submitted.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
