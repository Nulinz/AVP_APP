import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';
import '../../Controller/Testcardcontroller.dart';
import '../../Theme/Fonts.dart';
import 'Sidenavbar.dart';

class Testcard extends StatefulWidget {
  final int examid;
  const Testcard({
    super.key,
    required this.examid,
  });

  @override
  State<Testcard> createState() => _TestcardState();
}

class _TestcardState extends State<Testcard> {
  late Testcardcontroller testController;

  @override
  void initState() {
    super.initState();
    testController = Get.put(Testcardcontroller(examId: widget.examid));
  }

  Future<bool?> showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit Test?"),
        content: const Text(
          "Oops! You haven't submitted the test yet. If you leave, it will be auto-submitted. Do you still want to go back?",
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              testController.handleSubmit();
              Navigator.of(context).pop(true);
            },
            child: const Text("Yes, Exit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (testController.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return WillPopScope(
        onWillPop: () async {
          if (!testController.isSubmitted.value) {
            final shouldLeave = await showExitConfirmationDialog(context);
            return shouldLeave ?? false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 221, 215, 244),
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
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Exam: '),
                    Text(testController.subject.value),
                    const Spacer(),
                    const Text('Close In: '),
                    Obx(() => Text(
                          testController.formatTime(
                              testController.remainingSeconds.value),
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                linecontainer(
                  SizedBox(
                    width: double.infinity,
                    // give more height if needed
                    height: 150,
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attended Questions:',
                            style: AppTextStyles.heading.withColor(blackColor),
                          ),
                          SizedBox(height: 10.r),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Wrap(
                                spacing: 10.r,
                                runSpacing: 10.r,
                                children: List.generate(
                                  testController.questions.length,
                                  (index) {
                                    final questId = testController
                                        .questions[index]['question_id']
                                        .toString();
                                    final isAnswered = testController
                                        .selectedAnswers
                                        .containsKey(questId);

                                    return Container(
                                      width: 24.r,
                                      height: 24.r,
                                      decoration: BoxDecoration(
                                        color: isAnswered
                                            ? Colors.green
                                            : Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${index + 1}',
                                        style: AppTextStyles.small
                                            .withColor(whiteColor),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.r),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: linecontainer(
                      Padding(
                        padding: EdgeInsets.all(8.r),
                        child: ListView.builder(
                          itemCount: testController.questions.length + 1,
                          itemBuilder: (context, index) {
                            if (index == testController.questions.length) {
                              return Center(
                                child: ElevatedButton(
                                  onPressed: testController.isSubmitted.value
                                      ? null
                                      : () async {
                                          final shouldSubmit =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Submit Test?"),
                                              content: const Text(
                                                "Are you sure you want to submit the test? You cannot make changes afterward.",
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[300],
                                                    foregroundColor:
                                                        Colors.black,
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: const Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child:
                                                      const Text("Yes, Submit"),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (shouldSubmit == true) {
                                            testController.handleSubmit();
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.r, vertical: 16.r),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: const Text("Submit Test"),
                                ),
                              );
                            }

                            final question = testController.questions[index];
                            final questId = question['question_id'].toString();
                            final questionText =
                                "${index + 1}. ${question['question_name'] ?? ''}";

                            final options = [
                              question['option1'],
                              question['option2'],
                              question['option3'],
                              question['option4'],
                            ].whereType<String>().toList();

                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    questionText,
                                    style: AppTextStyles.subHeading
                                        .withColor(blackColor),
                                  ),
                                  SizedBox(height: 6.r),
                                  ...options.map((option) {
                                    final isSelected = testController
                                            .selectedAnswers[questId] ==
                                        option;
                                    return RadioListTile<String>(
                                      toggleable: true,
                                      // 👇 removed ValueKey to avoid duplicate key errors
                                      title: Text(option),
                                      value: option,
                                      groupValue: testController
                                          .selectedAnswers[questId],
                                      onChanged: testController
                                              .isSubmitted.value
                                          ? null
                                          : (value) {
                                              if (value == null) {
                                                testController.selectedAnswers
                                                    .remove(questId);
                                              } else {
                                                testController.selectedAnswers[
                                                    questId] = value;
                                              }
                                              testController.update();
                                            },
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
