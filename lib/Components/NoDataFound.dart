// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/Colors.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              height: Get.height / 1.4,
              width: Get.width / 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Image(
                  //   image: AssetImage("assets/Images/NoAchievements.png"),
                  // ),
                  Text(
                    "No Results Found",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: kPrimaryColor,
                        letterSpacing: .5,
                        fontSize: Get.width / 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Your WishList Empty",
                    // "Sorry! We couldn't find any results",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.black26,
                        letterSpacing: .5,
                        fontSize: Get.width / 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
