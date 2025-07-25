import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Backendservice/BackendService.dart';
import '../Backendservice/connectionService.dart';

class VideoController extends GetxController {
  var isLoading = false.obs;
  var enrollmentNo = ''.obs;
  var videoList = <Map<String, dynamic>>[].obs;
  var isFetchCompleted = false.obs;

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
      await fetchVideoList();
    } else {
      print("Enrollment number not found in SharedPreferences");
    }
  }

  Future<void> fetchVideoList() async {
    try {
      isLoading.value = true;
      isFetchCompleted.value = false;

      final response = await Backendservice.function(
        {
          "enrollment_no": enrollmentNo.value,
        },
        ConnectionService.videoListUrl,
        "POST",
      );

      if (response['status'] == "success") {
        videoList.value = List<Map<String, dynamic>>.from(response['videos']);
      } else {
        videoList.clear();
      }
    } catch (e) {
      print("Error fetching videos: $e");
      videoList.clear();
    } finally {
      isLoading.value = false;
      isFetchCompleted.value = true; 
    }
  }
}
