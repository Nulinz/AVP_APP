import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Backendservice/BackendService.dart';
import '../Backendservice/connectionService.dart';

class Questionandanswercontroller extends GetxController {
  var isLoading = false.obs;
  var exams = <Map<String, dynamic>>[].obs;
  var enrollmentNo = ''.obs;
  

  @override
  void onInit() {
    super.onInit();
    loadEnrollmentAndFetchExams();
  }

  Future<void> loadEnrollmentAndFetchExams() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEnrollmentNo = prefs.getString('enrollment_no');

    if (storedEnrollmentNo != null && storedEnrollmentNo.isNotEmpty) {
      enrollmentNo.value = storedEnrollmentNo;
      await fetchExams();
    } else {
      print("Enrollment number not found in SharedPreferences");
    }
  }

  Future<void> fetchExams() async {
    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {
          "enrollment_no": enrollmentNo.value,
          "button_type": "exams",
        },
        ConnectionService.curriculumList,
        "POST",
      );

      if (response['status'] == 'success') {
        exams.value = List<Map<String, dynamic>>.from(response['data']);
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
}
