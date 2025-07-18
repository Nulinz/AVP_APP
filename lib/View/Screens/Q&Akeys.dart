import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Theme/Colors.dart';

import 'package:sakthiexports/View/util/linecontainer.dart';

import 'Curriculam.dart';
import 'Keyanswer.dart';
import 'Questionpaper.dart';
import 'Sidenavbar.dart';

class CurriculumListPage extends StatelessWidget {
  const CurriculumListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 215, 244),
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
        title: const Text("AVP Siddha Academy"),
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
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Curriculum",
              style: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.r),
            linecontainer(
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RowText(label: "S.NO", value: "1"),
                    const RowText(
                      label: "Description",
                      value: "Model Test-1 (10.07.2025)",
                    ),
                    const RowText(label: "Subject", value: "Biology"),
                    const RowText(label: "Expiry", value: "12-07-2025"),
                    Row(
                      children: [
                        SizedBox(
                          width: 120.r,
                          child: Text(
                            "Question Paper:",
                            style: TextStyle(fontSize: 14.r),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: Get.width / 2.5,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => const Questionpaper());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "Question paper",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.r),
                    Row(
                      children: [
                        SizedBox(
                          width: 120.r,
                          child: Text(
                            "Answer Key:",
                            style: TextStyle(fontSize: 14.r),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: Get.width / 2.5,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => const Keyanswer());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "Answer Key",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.r),
                    Row(
                      children: [
                        SizedBox(
                          width: 120.r,
                          child: Text(
                            "Result:",
                            style: TextStyle(fontSize: 14.r),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: Get.width / 2.5,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => const CurriculumScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "View Result",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowText extends StatelessWidget {
  final String label;
  final String value;

  const RowText({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120.r,
              child: Text(
                "$label:",
                style: TextStyle(fontSize: 14.r),
              )),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 15.r),
            ),
          ),
        ],
      ),
    );
  }
}
