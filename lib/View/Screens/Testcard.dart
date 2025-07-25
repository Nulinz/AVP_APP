import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';
import '../../Theme/Fonts.dart';
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
  int _remainingSeconds = 2 * 60;
  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    attendedQuestions = List.generate(questions.length, (i) => '${i + 1}');
    startTimer();
  }
  

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        handleSubmit();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void handleSubmit({String? message}) {
    if (isSubmitted) return;
    _timer?.cancel();
    setState(() {
      isSubmitted = true;
    });
    Get.snackbar(
      "Test Submitted",
      message ?? "Your answers have been submitted.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
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
              handleSubmit(message: "Test auto-submitted!!");
              Navigator.of(context).pop(true);
            },
            child: const Text("Yes, Exit"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!isSubmitted) {
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
                        Text('Attended Questions:',
                            style: AppTextStyles.heading.withColor(blackColor)),
                        SizedBox(height: 10.r),
                        Wrap(
                          spacing: 10.r,
                          runSpacing: 10.r,
                          children:
                              List.generate(attendedQuestions.length, (index) {
                            final isAnswered =
                                selectedOptions.containsKey(index);
                            return Container(
                              width: 24.r,
                              height: 24.r,
                              decoration: BoxDecoration(
                                color: isAnswered ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(attendedQuestions[index],
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
                      itemCount: questions.length + 1,
                      itemBuilder: (context, index) {
                        if (index == questions.length) {
                          return Center(
                            child: ElevatedButton(
                              onPressed: isSubmitted
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
                                              child: const Text("Yes, Submit"),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (shouldSubmit == true) {
                                        handleSubmit();
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
                        final questionText = questions[index]['question'];
                        final options =
                            questions[index]['options'] as List<String>;
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
                                    selectedOptions[index] == option;
                                return RadioListTile<String>(
                                  toggleable: true,
                                  key: ValueKey(
                                      'q${index}_${option}_$isSelected'),
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
      ),
    );
  }
}
