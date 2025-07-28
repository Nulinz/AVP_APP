import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';
import '../../Controller/Testcardcontroller.dart';
import '../../Theme/Fonts.dart';
import 'Sidenavbar.dart';

class Testcard extends StatefulWidget {
  const Testcard({super.key});

  @override
  State<Testcard> createState() => _TestcardState();
}

class _TestcardState extends State<Testcard> {
  final TestController testController = Get.put(TestController());

  @override
  void initState() {
    super.initState();
    testController.fetchQuestions(examId: "660");
  }

  Future<bool?> showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit Test?"),
        content: const Text(
            "Oops! You haven't submitted the test yet. If you leave, it will be auto-submitted. Do you still want to go back?"),
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
              testController.handleSubmit(message: "Test auto-submitted!!");
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
                    Text(testController
                        .formatTime(testController.remainingSeconds.value)),
                  ],
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: whiteColor,
                  child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Attended Questions:',
                              style:
                                  AppTextStyles.heading.withColor(blackColor)),
                          SizedBox(height: 10.r),
                          Wrap(
                            spacing: 10.r,
                            runSpacing: 10.r,
                            children: List.generate(
                                testController.questions.length, (index) {
                              final isAnswered = testController.selectedOptions
                                  .containsKey(index);
                              return Container(
                                width: 24.r,
                                height: 24.r,
                                decoration: BoxDecoration(
                                  color: isAnswered ? Colors.green : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text('${index + 1}',
                                    style: AppTextStyles.small
                                        .withColor(whiteColor)),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.r),
                Expanded(
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
                                                "Are you sure you want to submit the test? You cannot make changes afterward."),
                                            actions: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  foregroundColor: Colors.black,
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text("Cancel"),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
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

                          final questionText =
                              "${index + 1}. ${testController.questions[index]['question']}";

                          final rawOptions =
                              testController.questions[index]['options'];
                          final options = List<String>.from(rawOptions);
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(questionText,
                                    style: AppTextStyles.subHeading
                                        .withColor(blackColor)),
                                SizedBox(height: 6.r),
                                ...options.map((option) {
                                  final isSelected =
                                      testController.selectedOptions[index] ==
                                          option;
                                  return RadioListTile<String>(
                                    toggleable: true,
                                    key: ValueKey(
                                        'q${index}_${option}_$isSelected'),
                                    title: Text(option),
                                    value: option,
                                    groupValue:
                                        testController.selectedOptions[index],
                                    onChanged: testController.isSubmitted.value
                                        ? null
                                        : (value) {
                                            if (value == null) {
                                              testController.selectedOptions
                                                  .remove(index);
                                            } else {
                                              testController
                                                      .selectedOptions[index] =
                                                  value;
                                            }
                                            testController.update();
                                          },
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                  );
                                }),
                              ],
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
      );
    });
  }
}
