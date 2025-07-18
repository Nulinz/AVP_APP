import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'Sidenavbar.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';

class Questionpaper extends StatefulWidget {
  const Questionpaper({super.key});

  @override
  State<Questionpaper> createState() => _QuestionpaperState();
}

class _QuestionpaperState extends State<Questionpaper> {
  final List<Map<String, dynamic>> questions = [
    {
      "question": "இதை மிகச் சேர்த்தால் அருசியமும், நெஞ்சிற் கபமும் விளையும்",
      "options": ["பழைய தேன்", "புதிய தேன்", "மனைத்த தேன்", "மலைத் தேன்"],
    },
    {
      "question": "ஷயம், அதிகூலம் முதலிய பிணிகளை நீக்குவது",
      "options": ["மலைத் தேன்", "கொம்புத் தேன்", "மரப்பொந்து", "மனைத்த தேன்"],
    },
    {
      "question": "சுராவின் செய்கை",
      "options": ["பால் பெறுக்கு", "வலிகொடுக்க", "நீரிழிவு", "உடல் வளர்ச்சி"],
    },
  ];

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
              "Curriculum : Test Exam - ANATOMY",
              style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.r),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final options = question["options"] as List<String>;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 16.r,
                    ),
                    child: linecontainer(
                      Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRow("S.NO", "${index + 1}", 1),
                            _buildRow("QUESTION", question["question"], 2),
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
        ),
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
