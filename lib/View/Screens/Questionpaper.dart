import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:avpsiddhacademy/Controller/Questionpapercontroller.dart';
import 'package:avpsiddhacademy/Theme/Colors.dart';
import 'package:avpsiddhacademy/View/util/linecontainer.dart';
import 'package:avpsiddhacademy/View/Screens/Sidenavbar.dart';

class Questionpaper extends StatefulWidget {
  final int examId;

  const Questionpaper({super.key, required this.examId});

  @override
  State<Questionpaper> createState() => _QuestionpaperState();
}

class _QuestionpaperState extends State<Questionpaper> {
  final Questionpapercontroller qController =
      Get.put(Questionpapercontroller());

  @override
  void initState() {
    super.initState();
    qController.fetchQuestions(examId: widget.examId);
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
        child: Obx(() {
          if (qController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (qController.questions.isEmpty) {
            return const Center(child: Text("No questions available."));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Curriculum : Test Exam - ANATOMY",
                style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.r),
              Expanded(
                child: ListView.builder(
                  itemCount: qController.questions.length,
                  itemBuilder: (context, index) {
                    final question = qController.questions[index];
                    final options = [
                      question['option1'],
                      question['option2'],
                      question['option3'],
                      question['option4']
                    ];

                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.r),
                      child: linecontainer(
                        Padding(
                          padding: EdgeInsets.all(12.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRow("S.NO", "${index + 1}", 1),
                              _buildRow(
                                  "QUESTION", question["question_name"], 2),
                              for (int i = 0; i < options.length; i++)
                                _buildRow("OPTION-${i + 1}", options[i], i + 3),
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
      ),
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
                width: 100.r,
                child: Text(
                  "$label :",
                  style: TextStyle(fontSize: 10.r, color: greyColor),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
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
