import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:avpsiddhacademy/Theme/Colors.dart';
import 'package:avpsiddhacademy/Theme/Fonts.dart';
import 'package:avpsiddhacademy/View/util/linecontainer.dart';
import 'package:shimmer/shimmer.dart';
import '../../Controller/Questionandanswercontroller.dart';
import 'ViewresultScreen.dart';
import 'Keyanswer.dart';
import 'Questionpaper.dart';
import 'Sidenavbar.dart';

class CurriculumListPage extends StatefulWidget {
  const CurriculumListPage({super.key, r});

  @override
  State<CurriculumListPage> createState() => _CurriculumListPageState();
}

class _CurriculumListPageState extends State<CurriculumListPage> {
  final controller = Get.put(Questionandanswercontroller());

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
          title: Text(
            "AVP Siddha Academy",
            style: AppTextStyles.heading,
          ),
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
          child: Obx(() {
            if (controller.isLoading.value) {
              return curriculumShimmer();
            }

            if (controller.exams.isEmpty) {
              return Center(
                  child: Text("No exams found",
                      style: AppTextStyles.subHeading.withColor(blackColor)));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Curriculum:",
                    style: AppTextStyles.subHeading.withColor(blackColor)),
                SizedBox(height: 12.r),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.exams.length,
                    itemBuilder: (context, index) {
                      final exam = controller.exams[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.r),
                        child: linecontainer(
                          Padding(
                            padding: EdgeInsets.all(12.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RowText(label: "S.NO", value: "${index + 1}"),
                                RowText(
                                    label: "Description",
                                    value: exam['exam_title'] ?? ''),
                                RowText(
                                    label: "Subject",
                                    value: exam['subject'] ?? ''),
                                RowText(
                                    label: "Expiry",
                                    value: exam['expiry_date'] ?? ''),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120.r,
                                      child: Text("Question Paper:",
                                          style: AppTextStyles.small
                                              .withColor(blackColor)),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: Get.width / 2.5,
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            Get.to(() => Questionpaper(
                                                  examId: int.parse(
                                                      exam['exam_id']
                                                          .toString()),
                                                )),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        child: Text("Question paper",
                                            style: AppTextStyles.small
                                                .withColor(whiteColor)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.r),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120.r,
                                      child: Text("Answer Key:",
                                          style: AppTextStyles.small
                                              .withColor(blackColor)),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: Get.width / 2.5,
                                      child: ElevatedButton(
                                        onPressed: () => Get.to(() => Keyanswer(
                                              examId: int.parse(
                                                  exam['exam_id'].toString()),
                                            )),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        child: Text("Answer Key",
                                            style: AppTextStyles.small
                                                .withColor(whiteColor)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.r),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120.r,
                                      child: Text("Result:",
                                          style: AppTextStyles.small
                                              .withColor(blackColor)),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: Get.width / 2.5,
                                      child: ElevatedButton(
                                        onPressed: () => Get.to(
                                          () => ViewresultScreen(
                                            examId: int.parse(
                                                exam['exam_id'].toString()),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                        ),
                                        child: Text("View Result",
                                            style: AppTextStyles.small
                                                .withColor(whiteColor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ));
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
                style: AppTextStyles.small.withColor(blackColor),
              )),
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

Widget curriculumShimmer() {
  return ListView.builder(
    itemCount: 4,
    itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.r),
        child: linecontainer(
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerRow(labelWidth: 120.r, height: 12.r),
                  SizedBox(height: 8.r),
                  _shimmerRow(labelWidth: 120.r, height: 12.r),
                  SizedBox(height: 8.r),
                  _shimmerRow(labelWidth: 120.r, height: 12.r),
                  SizedBox(height: 8.r),
                  _shimmerRow(labelWidth: 120.r, height: 12.r),
                  SizedBox(height: 16.r),
                  _shimmerButtonRow(),
                  SizedBox(height: 12.r),
                  _shimmerButtonRow(),
                  SizedBox(height: 12.r),
                  _shimmerButtonRow(),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _shimmerRow({required double labelWidth, required double height}) {
  return Row(
    children: [
      Container(
        width: labelWidth,
        height: height,
        color: Colors.white,
      ),
      const Spacer(),
      Container(
        width: 100.r,
        height: height,
        color: Colors.white,
      ),
    ],
  );
}

Widget _shimmerButtonRow() {
  return Row(
    children: [
      Container(
        width: 120.r,
        height: 12.r,
        color: Colors.white,
      ),
      const Spacer(),
      Container(
        width: Get.width / 2.5,
        height: 36.r,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    ],
  );
}
