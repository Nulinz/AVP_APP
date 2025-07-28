import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/View/Screens/Testcard.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';
import '../../Controller/Subjectexamcontroller.dart';
import '../../Theme/Fonts.dart';
import 'ViewresultScreen.dart';
import 'Notificationscreen.dart';
import 'Profile.dart';
import 'Q&Akeys.dart';
import 'Sidenavbar.dart';
import 'Videosample.dart';

class CurriculumDashboard extends StatefulWidget {
  const CurriculumDashboard({super.key});

  @override
  State<CurriculumDashboard> createState() => _CurriculumDashboardState();
}

class _CurriculumDashboardState extends State<CurriculumDashboard> {
  final ExamController examController = Get.put(ExamController());

  double _opacity = 1.0;
  late Timer _timer;
  final List<Map<String, String>> notifications = [
    {
      "title": "Model Test",
      "description": "009 Batch 13.07.2025 (Sunday) Test portion Test portion",
    },
  ];
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _opacity = _opacity == 1.0 ? 0.0 : 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await examController.fetchExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: Get.width * 0.8,
        child: SideNavbarDrawer(),
      ),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
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
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 221, 215, 244),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.r,
                      width: double.infinity,
                      color: Colors.white,
                      child: buildMarqueeText(
                        ' Welcome to AVP Siddha Academy! Please follow the instructions before starting the test.',
                      ),
                    ),
                    SizedBox(height: 10.r),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.r),
                      child: Text("Curriculum:", style: AppTextStyles.body),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DashboardCard(
                              icon: Image.asset('assets/Icons/Question.png'),
                              label: "Q & A Keys",
                              onTap: () {
                                Get.to(() => const CurriculumListPage());
                              }),
                          const SizedBox(width: 5),
                          DashboardCard(
                            icon: Image.asset('assets/Icons/student.png'),
                            label: "My Profile",
                            onTap: () {
                              Get.to(() => const ProfileScreen());
                            },
                          ),
                          SizedBox(width: 5.r),
                          DashboardCard(
                            icon: Image.asset('assets/Icons/Video.png'),
                            label: "Videos",
                            onTap: () {
                              Get.to(() => const SampleVideoListPlayer());
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.r),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.r),
                          child: AnimatedOpacity(
                            opacity: _opacity,
                            duration: const Duration(milliseconds: 500),
                            child: Row(
                              children: [
                                const Icon(Icons.notifications_active,
                                    color: Colors.red),
                                SizedBox(width: 8.r),
                                Text(
                                  "Updates:",
                                  style: AppTextStyles.body,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.r),
                          child: IconButton(
                            onPressed: () {
                              Get.to(() => const Notificationscreen());
                            },
                            icon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "View All",
                                  style: AppTextStyles.body,
                                ),
                                SizedBox(width: 4.r),
                                Icon(Icons.arrow_forward_outlined,
                                    size: 14.r, color: kPrimaryColor),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: SizedBox(
                        width: 350,
                        child: linecontainer(
                          Padding(
                            padding: EdgeInsets.all(12.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.r),
                                Padding(
                                  padding: EdgeInsets.all(8.r),
                                  child: Text("Model Test ",
                                      style: AppTextStyles.subHeading
                                          .withColor(blackColor)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.r),
                                  child: Text(
                                      "009 Batch  13.07.2025 (Sunday) Test portion Test portion ",
                                      style: AppTextStyles.small
                                          .withColor(blackColor)),
                                ),
                                SizedBox(height: 12.r),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.r),
                    Obx(() {
                      if (examController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (examController.exams.isEmpty) {
                        return buildSubjectCard(
                          title: 'Subject of Exam:',
                          canStart: false,
                          onTap: () {},
                          message: 'No exams available.',
                        );
                      }

                      return Column(
                        children: examController.exams.map((exam) {
                          final canStart = examController.canStartExam(
                            exam['exam_time'],
                            exam['exam_end'],
                          );

                          return buildSubjectCard(
                            title: exam['exam_title'],
                            canStart: canStart,
                            onTap: () {
                              if (canStart) {
                                Get.to(() =>  Testcard(examid: exam['exam_id'],))?.then((_) {
                                  _refreshData();
                                });
                              } else {
                                final startTime = DateFormat('hh:mm a').format(
                                  DateFormat('HH:mm').parse(exam['exam_time']),
                                );
                                final endTime = DateFormat('hh:mm a').format(
                                  DateFormat('HH:mm').parse(exam['exam_end']),
                                );

                                Get.snackbar(
                                  "Unavailable",
                                  "Test is only available between $startTime and $endTime",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                );
                              }
                            },
                          );
                        }).toList(),
                      );
                    }),
                    SizedBox(height: 10.r),
                    buildExamScheduleCard(
                      scheduleDate: "13.07.2025",
                      subjects: [
                        {"subject": "Biology", "description": "Full Syllabus"},
                        {
                          "subject": "Physics",
                          "description": "Chapters 1 to 4"
                        },
                      ],
                    ),
                    SizedBox(height: 20.r),
                    buildModelTestCard(
                      title: "Model Test - 1 (06.07.2025)",
                      onViewResult: () {
                        // Get.to(() => ViewresultScreen(examId:exam['exam_id'].toString()));
                      },
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

// Dashboard card main
class DashboardCard extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: linecontainer(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 10.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 32.r, child: Center(child: icon)),
                SizedBox(height: 8.r),
                Text(
                  label,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Marquee card main
Widget buildMarqueeText(String message) {
  return Marquee(
    text: message,
    style: AppTextStyles.body,
    scrollAxis: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    blankSpace: 60.0,
    velocity: 40.0,
    pauseAfterRound: const Duration(seconds: 1),
    startPadding: 10.0,
    accelerationDuration: const Duration(seconds: 1),
    accelerationCurve: Curves.linear,
    decelerationDuration: const Duration(milliseconds: 500),
    decelerationCurve: Curves.easeOut,
  );
}

// schedule card main
Widget buildExamScheduleCard({
  required String scheduleDate,
  required List<Map<String, String>> subjects,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(10.r),
        child: linecontainer(
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Schedule",
                      style: AppTextStyles.subHeading,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.r, vertical: 6.r),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        scheduleDate,
                        style: AppTextStyles.body.withColor(whiteColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.r),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.r, horizontal: 12.r),
                  color: kPrimaryColor,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("#", style: AppTextStyles.small),
                      ),
                      SizedBox(width: 80.r),
                      Expanded(
                        flex: 3,
                        child: Text("Subject", style: AppTextStyles.small),
                      ),
                      SizedBox(width: 10.r),
                      Expanded(
                        flex: 5,
                        child: Text("Description", style: AppTextStyles.small),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ...subjects.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final subject = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.r),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text("$index",
                              style: AppTextStyles.small.withColor(blackColor)),
                        ),
                        SizedBox(width: 80.r),
                        Expanded(
                          flex: 3,
                          child: Text(
                            subject['subject'] ?? '',
                            style: AppTextStyles.small.withColor(blackColor),
                          ),
                        ),
                        SizedBox(width: 10.r),
                        Expanded(
                          flex: 5,
                          child: Text(
                            subject['description'] ?? '',
                            style: AppTextStyles.small.withColor(blackColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

// Subject card main
Widget buildSubjectCard({
  required String title,
  required bool canStart,
  required VoidCallback onTap,
  String? message, // optional message
}) {
  return Padding(
    padding: EdgeInsets.all(8.r),
    child: SizedBox(
      width: double.infinity,
      child: Card(
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.subHeading.withColor(whiteColor)),
              SizedBox(height: 10.r),

              // Show button if canStart, else show message
              canStart
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: onTap,
                      child: Text(
                        'Start Test',
                        style: AppTextStyles.small.withColor(whiteColor),
                      ),
                    )
                  : Text(
                      message ?? 'You cannot start the test at this time.',
                      style: AppTextStyles.small.withColor(whiteColor),
                    ),
            ],
          ),
        ),
      ),
    ),
  );
}

// test card mian
Widget buildModelTestCard({
  required String title,
  required VoidCallback onViewResult,
}) {
  return Padding(
    padding: EdgeInsets.all(8.r),
    child: Card(
      color: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Text(
                title,
                style: AppTextStyles.subHeading.withColor(whiteColor),
              ),
            ),
            SizedBox(height: 12.r),
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                onPressed: onViewResult,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "View Result",
                  style: AppTextStyles.small.withColor(whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
