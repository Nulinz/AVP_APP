import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Backendservice/BackendService.dart';
import '../Backendservice/connectionService.dart';

class ExamController extends GetxController {
  var exams = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExams();
  }

  Future<void> fetchExams() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final enrollmentNo = prefs.getString('enrollment_no');

      if (enrollmentNo == null) return;

      final response = await Backendservice.function(
        {
          "enrollment_no": enrollmentNo,
          "button_type": "get_exam",
        },
        ConnectionService.examstart,
        "POST",
      );

      if (response['status'] == 'success') {
        exams.assignAll(List<Map<String, dynamic>>.from(response['data']));
      } else {
        exams.clear();
      }
    } catch (e) {
      print("Error fetching exams: $e");
      exams.clear();
    } finally {
      isLoading.value = false;
    }
  }

  bool canStartExam(String examTime, String examEnd) {
    try {
      final now = DateTime.now();
      final nowTime =
          DateFormat("HH:mm").parse(DateFormat('HH:mm').format(now));
      final startTime = DateFormat("HH:mm").parse(_normalizeTime(examTime));
      final endTime = DateFormat("HH:mm").parse(_normalizeTime(examEnd));

      return (nowTime.isAfter(startTime) ||
              nowTime.isAtSameMomentAs(startTime)) &&
          nowTime.isBefore(endTime);
    } catch (e) {
      print("Time parse error: $e");
      return false;
    }
  }

  String _normalizeTime(String timeStr) {
    final parts = timeStr.split(":");
    if (parts.length == 2) {
      final hour = parts[0].padLeft(2, '0');
      final minute = parts[1].padLeft(2, '0');
      return "$hour:$minute";
    }
    return timeStr;
  }
}
