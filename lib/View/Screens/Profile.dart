import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';
import '../../Controller/Profilecontroller.dart';
import '../../Theme/Fonts.dart';
import 'Sidenavbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 221, 215, 244),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
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
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (profileController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                children: [
                  SizedBox(height: 10.r),
                  linecontainer(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                            ),
                          ),
                          padding: EdgeInsets.all(10.r),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                    'https://cdn3.iconfinder.com/data/icons/web-design-and-development-2-6/512/87-1024.png'),
                              ),
                              SizedBox(width: 16.r),
                              Expanded(
                                child: Text(
                                  profileController.Name.value,
                                  style: AppTextStyles.subHeading
                                      .withColor(whiteColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: profileController.profileData.map((item) {
                              return RowItem(
                                label: item['label']!,
                                value: item['value']!,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  final String label;
  final String value;

  const RowItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.r,
            child: Text("$label:",
                style: AppTextStyles.small.withColor(blackColor)),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: AppTextStyles.small.withColor(blackColor)),
          ),
        ],
      ),
    );
  }
}
