// import 'package:get/get.dart';
// import '../Backendservice/BackendService.dart';
// import '../Backendservice/connectionService.dart';


// class ProfileController extends GetxController {
//   final int empId;

//   var isLoading = false.obs;
//   var profileData = <Map<String, String>>[].obs;

//   ProfileController(this.empId);

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfileData();
//   }

//   Future<void> fetchProfileData() async {
//     try {
//       isLoading.value = true;

//       final response = await Backendservice.function(
//         {},
//         "${ConnectionService.profileDetails}?emp_id=$empId",
//         "GET",
//       );

//       if (response['success'] == true) {
//         final data = response['data'];

//         profileData.value = [
//           {"label": "Name", "value": data['name'] ?? "NA"},
//           {"label": "Email", "value": data['email'] ?? "NA"},
//           {"label": "Mobile", "value": data['mobile'] ?? "NA"},
//           {"label": "DOB", "value": data['dob'] ?? "NA"},
//           {"label": "Gender", "value": data['gender'] ?? "NA"},
//           {"label": "Address", "value": data['address'] ?? "NA"},
//         ];
//       } else {
//         profileData.clear();
//       }
//     } catch (e) {
//       print("Error fetching profile data: $e");
//       profileData.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
