import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Backendservice/BackendService.dart';
import '../Backendservice/connectionService.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var Name = ''.obs;
  var profileData = <Map<String, String>>[].obs;
  var enrollmentNo = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfileFromPrefs();
  }

  Future<void> loadProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEnrollmentNo = prefs.getString('enrollment_no');

    if (storedEnrollmentNo != null && storedEnrollmentNo.isNotEmpty) {
      enrollmentNo.value = storedEnrollmentNo;
      await fetchProfileData();
    } else {
      print("Enrollment number not found in SharedPreferences");
    }
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;

      final response = await Backendservice.function(
        {
          "enrollment_no": enrollmentNo.value,
          "button_type": "profile",
        },
        ConnectionService.profile,
        "POST",
      );

      if (response['status'] == 'success') {
        final data = response['profile'];

        Name.value = data['student_name'] ?? 'NA';

        profileData.value = [
          {"label": "Name", "value": data['student_name'] ?? "NA"},
          {"label": "Enrollment No", "value": data['enroll_no'] ?? "NA"},
          {"label": "Father Name", "value": data['father_name'] ?? "NA"},
          {"label": "Mother Name", "value": data['mother_name'] ?? "NA"},
          {"label": "Gender", "value": data['gender'] ?? "NA"},
          {"label": "Contact No", "value": data['contact'] ?? "NA"},
          {"label": "Email", "value": data['mail_id'] ?? "NA"},
          {"label": "Address", "value": data['address'] ?? "NA"},
        ];
      } else {
        profileData.clear();
      }
    } catch (e) {
      print("Error fetching profile data: $e");
      profileData.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
