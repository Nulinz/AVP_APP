import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebarcontroller extends GetxController {
  var employeeId = 0.obs;
  var employeeName = ''.obs;
  var employeeImg = ''.obs;
  var empcode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    employeeId.value = pref.getInt("employee_id") ?? 0;
    empcode.value = pref.getString("empcode") ?? '';

    employeeName.value = pref.getString("employee_name") ?? '';
    employeeImg.value = pref.getString("employee_img") ?? '';
  }
}
