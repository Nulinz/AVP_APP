import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:avpsiddhacademy/Controller/KeyAnswerController.dart';
import 'package:avpsiddhacademy/View/util/linecontainer.dart';
import 'Sidenavbar.dart';

class Keyanswer extends StatefulWidget {
  final int examId;

  const Keyanswer({
    super.key,
    required this.examId,
  });

  @override
  State<Keyanswer> createState() => _KeyanswerState();
}

class _KeyanswerState extends State<Keyanswer> {
  final keyanswerController = Get.put(Keyanswercontroller());

  @override
  void initState() {
    super.initState();

    keyanswerController.fetchAnswers(examId: widget.examId);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Curriculum :",
              style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.r),
            Obx(() {
              if (keyanswerController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (keyanswerController.answers.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 350),
                      Text("No answers found"),
                    ],
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: keyanswerController.answers.length,
                  itemBuilder: (context, index) {
                    final q = keyanswerController.answers[index];
                    final correctAnswer = q['correct_answer'] ?? '';
                    final userAnswer = q['answer_status'] ?? '';
                    final isCorrect = correctAnswer == userAnswer;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.r),
                      child: linecontainer(
                        Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRow("S.NO", "${index + 1}", 0),
                              _buildRow("QUESTION", q['question'] ?? '', 1),
                              _buildRow("ANSWER", correctAnswer, 2,
                                  valueColor: Colors.green),
                              _buildRow("USER ANSWER", userAnswer, 3,
                                  valueColor:
                                      isCorrect ? Colors.green : Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, int index, {Color? valueColor}) {
    bool isEven = index % 2 == 0;

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
                  style: TextStyle(fontSize: 10.r, color: Colors.grey),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12.r,
                    color: valueColor ?? Colors.black,
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
