import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';
import 'Sidenavbar.dart';

class Keyanswer extends StatefulWidget {
  const Keyanswer({super.key});

  @override
  State<Keyanswer> createState() => _KeyanswerState();
}

class _KeyanswerState extends State<Keyanswer> {
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
            Expanded(
              child: ListView.builder(
                itemCount: questionData.length,
                itemBuilder: (context, index) {
                  final q = questionData[index];
                  final isCorrect = q['answer'] == q['userAnswer'];
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
                            _buildRow("ANSWER", q['answer'] ?? '', 2,
                                valueColor: Colors.green),
                            _buildRow("USER ANSWER", q['userAnswer'] ?? '', 3,
                                valueColor:
                                    isCorrect ? Colors.green : Colors.red),
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

final List<Map<String, String>> questionData = [
  {
    "question": "இதனை மிகச் சேர்த்தால் அருசியும், நெஞ்சிற் கபமும் விளையும்",
    "answer": "புதிய தேன்",
    "userAnswer": "பழைய தேன்",
  },
  {
    "question": "ஷயம், அதிகாலம் முதலிய பிணிகளை நீக்குவது",
    "answer": "மரப்பொந்து தேன்",
    "userAnswer": "மரப்பொந்து தேன்",
  },
  {
    "question": "தேன் எத்தனை நாடிகளில் சிறந்ததாகும்",
    "answer": "12",
    "userAnswer": "12",
  },
];
