import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:avpsiddhacademy/Theme/Colors.dart';
import 'package:avpsiddhacademy/View/Screens/Sidenavbar.dart';
import 'package:avpsiddhacademy/View/util/linecontainer.dart';
import '../../Controller/ViewresultScreencontroller.dart';
import '../../Theme/Fonts.dart';

class ViewresultScreen extends StatefulWidget {
  final int examId;
  ViewresultScreen({super.key, required this.examId});

  @override
  State<ViewresultScreen> createState() => _ViewresultScreenState();
}

class _ViewresultScreenState extends State<ViewresultScreen> {
  final controller = Get.put(ViewresultScreencontroller());

  @override
  void initState() {
    super.initState();

    controller.fetchExamResult(examId: widget.examId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 215, 244),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SideNavbarDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          );
        }

        if (controller.summaryData.isEmpty) {
          return const Center(
            child: Text("No exam result found."),
          );
        }

        return Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Curriculum : ${controller.summaryData.firstWhereOrNull((e) => e['label'] == 'EXAM')?['value'] ?? 'N/A'}",
                style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.r),
              linecontainer(
                Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exam name row at top
                      _buildRow(
                        "EXAM",
                        controller.summaryData.firstWhereOrNull(
                                (e) => e['label'] == 'EXAM')?['value'] ??
                            'N/A',
                        -1, // Special index to remove background color
                      ),

                      // Other rows
                      ...controller.summaryData
                          .where((item) =>
                              item['label'] != 'EXAM' &&
                              item['label'] != 'S.NO')
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) => _buildRow(
                                entry.value['label']!,
                                entry.value['value']!,
                                entry.key,
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRow(String label, String value, int lineIndex) {
    bool isEven = lineIndex % 2 == 0;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 10.r),
          color: isEven
              ? const Color.fromARGB(255, 234, 230, 255)
              : Colors.transparent,
          child: Row(
            children: [
              SizedBox(
                width: 120.r,
                child: Text(
                  "$label :",
                  style: TextStyle(
                      fontSize: 12.r,
                      color: darkGreyColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12.r,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1.r, color: Colors.grey),
      ],
    );
  }
}
