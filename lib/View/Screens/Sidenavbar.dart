import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sakthiexports/Theme/Colors.dart';

import 'package:sakthiexports/View/LoginRegister/Loginpage.dart';

import '../../Controller/Sidenavbarcontroller.dart';
import 'Downlodedvideo.dart';
import 'Homepage.dart';
import 'Profile.dart';
import 'Q&Akeys.dart';
import 'Videosample.dart';


class SideNavbarDrawer extends StatelessWidget {
  SideNavbarDrawer({super.key});

  final Sidebarcontroller controller = Get.put(Sidebarcontroller());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryColor,
      child: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 32.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.r),
                CircleAvatar(
                  radius: 40.r,
                  backgroundImage: controller.employeeImg.value.isNotEmpty
                      ? CachedNetworkImageProvider(controller.employeeImg.value)
                      : const AssetImage("assets/images/ProfileAvatar.jpg")
                          as ImageProvider,
                ),
                SizedBox(height: 12.r),
                Text(
                  "Dr. NAVEEN BALAJI V",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6.r),
                Text(
                  "AVP2025009581",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  "PG NEET 009 Batch 2024 - 2026",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.r),
                _item(Icons.dashboard, "Dashboard", () {
                  Navigator.pop(context);
                  Get.to(() => const CurriculumDashboard());
                }),
                _item(Icons.person, "My Profile", () {
                  Navigator.pop(context);
                  Get.to(() => const ProfileScreen());
                }),
                _item(Icons.library_books, "Question & Keys", () {
                  Navigator.pop(context);
                  Get.to(() => const CurriculumListPage());
                }),
                _item(Icons.video_library, "Video", () {
                  Navigator.pop(context);

                  Get.to(() => const SampleVideoListPlayer());
                }),
                _item(Icons.cloud_download_sharp, "My Downloads", () {
                  Navigator.pop(context);

                  Get.to(() => const DownloadedVideoList());
                }),
                _item(Icons.logout, "Sign Out", () {
                  Get.offAll(() => const LoginPage());
                  Get.snackbar("Logout", "You have been logged out.");
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(IconData ico, String title, VoidCallback tap) => ListTile(
        dense: true,
        onTap: tap,
        leading: Icon(ico, color: Colors.white, size: 22.r),
        title: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 16.r,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
}
