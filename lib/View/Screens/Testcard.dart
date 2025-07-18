import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';

import 'Sidenavbar.dart';

class Testcard extends StatefulWidget {
  const Testcard({super.key});

  @override
  State<Testcard> createState() => _TestcardState();
}

class _TestcardState extends State<Testcard> {
  late final List<String> attendedQuestions;
  final List<Map<String, dynamic>> questions = [
    {
      'question':
          '1 - இதனை மிகச் சேர்த்தால் அருசியும், நெஞ்சிற் கபமும் விளையும்',
      'options': ['பலூசு தேன்', 'புதிய தேன்', 'மணசுர் தேன்', 'மலைச் தேன்'],
    },
    {
      'question': '2 - ஞாயிறு, அதிகாலம் முதலிய பிணிகளை நீக்குவது',
      'options': ['மலைச் தேன்', 'கொம்பூச் தேன்', 'பரம்பூட்டி', 'மனையி தேன்'],
    },
    {
      'question': '3 - சூறையின் செய்கை',
      'options': [
        'பால் பெறுக்கி',
        'வாதகமில்லை',
        'புதிய உடலுக்காற்றி',
        'மேற்சட்டை அனைத்தும்'
      ],
    },
    {
      'question': '4 - பஞ்சகண்டபாலின் பயன்',
      'options': [
        'ஏலும்பு செய்ய',
        'செங்கற் செய்ய',
        'ஹரமண நதிந் செய்ய',
        'மரண நங்கை முறிக்க'
      ],
    },
  ];

  Map<int, String> selectedOptions = {};
  Timer? _timer;
  int _remainingSeconds = 15 * 60;
  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    attendedQuestions = List.generate(questions.length, (i) => '${i + 1}');
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        handleSubmit();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void handleSubmit() {
    if (isSubmitted) return;
    _timer?.cancel();
    setState(() {
      isSubmitted = true;
    });
    Get.snackbar(
      "Test Submitted",
      "Your answers have been submitted.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          "AVP Siddha Academy",
          style: TextStyle(fontSize: 18.r, fontWeight: FontWeight.bold),
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
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Exam: '),
                const Text('Text Exam'),
                const Spacer(),
                const Text('Close In: '),
                Text(formatTime(_remainingSeconds)),
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
                      Text(
                        'Attended Questions:',
                        style: TextStyle(
                            fontSize: 16.r, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.r),
                      Wrap(
                        spacing: 10.r,
                        runSpacing: 10.r,
                        children:
                            List.generate(attendedQuestions.length, (index) {
                          final isAnswered = selectedOptions.containsKey(index);
                          return Container(
                            width: 24.r,
                            height: 24.r,
                            decoration: BoxDecoration(
                              color: isAnswered ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              attendedQuestions[index],
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.r),
                            ),
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
                    itemCount: questions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == questions.length) {
                        return Center(
                          child: ElevatedButton(
                            onPressed: isSubmitted ? null : handleSubmit,
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
                      final questionText = questions[index]['question'];
                      final options =
                          questions[index]['options'] as List<String>;
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              questionText,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6.r),
                            ...options.map((option) {
                              final isSelected =
                                  selectedOptions[index] == option;
                              return RadioListTile<String>(
                                toggleable: true,
                                key:
                                    ValueKey('q${index}_${option}_$isSelected'),
                                title: Text(option),
                                value: option,
                                groupValue: selectedOptions[index],
                                onChanged: isSubmitted
                                    ? null
                                    : (value) {
                                        setState(() {
                                          if (value == null) {
                                            selectedOptions.remove(index);
                                          } else {
                                            selectedOptions[index] = value;
                                          }
                                        });
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
    );
  }
}
