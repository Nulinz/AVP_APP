import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakthiexports/Theme/Colors.dart';
import 'package:sakthiexports/View/Screens/Sidenavbar.dart';
import 'package:sakthiexports/View/util/linecontainer.dart';

class CurriculumScreen extends StatelessWidget {
  const CurriculumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> data = [
      {"label": "S.NO", "value": "1"},
      {"label": "EXAM", "value": "Model Test (10.07.2025)"},
      {"label": "TOTAL Qns", "value": "100"},
      {"label": "NOT ANSWER", "value": "50"},
      {"label": "CORRECT", "value": "45"},
      {"label": "WRONG", "value": "5"},
      {"label": "MARKS", "value": "0"},
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 215, 244),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SideNavbarDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding:  EdgeInsets.all(8.r),
          child: SizedBox(
            width: 50.r,
            height: 50.r,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text("AVP Siddha Academy"),
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
      body: Padding(
        padding:  EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "Curriculum",
              style: TextStyle(fontSize: 20.r, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 12.r),
            linecontainer(
              Padding(
                padding:  EdgeInsets.all(8.r),
                child: Column(
                  children: List.generate(data.length, (index) {
                    final item = data[index];
                    final isEven = (index + 1) % 2 == 0;

                    return Column(
                      children: [
                        Container(
                          color: isEven
                              ? const Color.fromARGB(255, 234, 230, 255)
                              : Colors.transparent,
                          padding:  EdgeInsets.symmetric(
                              vertical: 10.r, horizontal: 10.r),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 120.r,
                                child: Text(
                                  "${item['label']}:",
                                  style:  TextStyle(
                                      fontSize: 10.r, color: greyColor),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item['value'] ?? "",
                                  textAlign: TextAlign.end,
                                  style:  TextStyle(fontSize: 12.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                         Divider(height: 1.r, color: Colors.grey),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// // Obx(() {
//   if (controller.isLoading.value) {
//     return const Center(child: CircularProgressIndicator());
//   }

//   if (controller.summaryData.isEmpty) {
//     return const Center(child: Text("No curriculum data found."));
//   }

//   return linecontainer(
//     Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: List.generate(controller.summaryData.length, (index) {
//           final item = controller.summaryData[index];
//           final isEven = (index + 1) % 2 == 0;

//           return Column(
//             children: [
//               Container(
//                 color: isEven
//                     ? const Color.fromARGB(255, 234, 230, 255)
//                     : Colors.transparent,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 120,
//                       child: Text(
//                         "${item['label']}:",
//                         style: const TextStyle(fontSize: 10, color: greyColor),
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         item['value'] ?? "",
//                         textAlign: TextAlign.end,
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1, color: Colors.grey),
//             ],
//           );
//         }),
//       ),
//     ),
//   );
// })
