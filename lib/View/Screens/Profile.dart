import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:avpsiddhacademy/Theme/Colors.dart';
import 'package:avpsiddhacademy/View/util/linecontainer.dart';
import 'package:shimmer/shimmer.dart';
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
            return profileShimmer();
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

Widget profileShimmer() {
  return SingleChildScrollView(
    padding: EdgeInsets.all(12.r),
    child: Column(
      children: [
        SizedBox(height: 10.r),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with shimmer avatar and name
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
                padding: EdgeInsets.all(12.r),
                child: Row(
                  children: [
                    _shimmerCircle(radius: 30.r),
                    SizedBox(width: 16.r),
                    Expanded(child: _shimmerLine(width: 180.w, height: 20.h)),
                  ],
                ),
              ),

              // Profile key-value items shimmer
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: List.generate(
                    6, // Number of profile rows to shimmer
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          _shimmerLine(width: 100.w, height: 14.h), // Label
                          SizedBox(width: 12.w),
                          Expanded(
                              child: _shimmerLine(
                                  width: 200.w, height: 14.h)), // Value
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _shimmerLine({required double width, required double height}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
    ),
  );
}

Widget _shimmerCircle({required double radius}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    ),
  );
}
