import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Controller/NotificationController.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';
import '../../Theme/Fonts.dart';
import 'Sidenavbar.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  State<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    controller.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 221, 215, 244),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          width: Get.width * 0.8,
          child: SideNavbarDrawer(),
        ),
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.all(8.r),
            child: SizedBox(
              width: 50.r,
              height: 50.r,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          title: Text("AVP Siddha Academy", style: AppTextStyles.heading),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(2.r),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Top Update", style: AppTextStyles.bodyLuckiest),
                SizedBox(height: 8.r),
                Expanded(
                  child: buildTopUpdateSection(controller.notifications),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

Widget buildTopUpdateSection(List<Map<String, String>> notifications) {
  return Padding(
    padding: EdgeInsets.all(2.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2.r),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Padding(
                  padding: EdgeInsets.all(8.r),
                  child: linecontainer(
                    Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.r),
                          Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/Icons/check.png',
                                  width: 24.r,
                                  height: 24.r,
                                ),
                                SizedBox(width: 8.r),
                                Expanded(
                                  child: Text(item['title'] ?? '',
                                      style: AppTextStyles.subHeading
                                          .withColor(blackColor)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Text(item['description'] ?? '',
                                style:
                                    AppTextStyles.small.withColor(blackColor)),
                          ),
                          SizedBox(height: 1.r),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}
