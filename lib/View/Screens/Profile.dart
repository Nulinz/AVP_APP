import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakthiexports/Theme/Colors.dart';

import 'Sidenavbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 221, 215, 244),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              children: [
                SizedBox(height: 10.r),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            topRight: Radius.circular(12.r),
                          ),
                        ),
                        padding: EdgeInsets.all(10.r),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/ProfileAvatar.jpg'),
                            ),
                            SizedBox(width: 16.r),
                            Expanded(
                              child: Text(
                                "DR. NAVEEN BALAJI V",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RowItem(
                                label: "Enrollment No", value: "AVP202509031"),
                            RowItem(label: "Father Name", value: "VENKATESAN"),
                            RowItem(label: "Mother Name", value: "RAM"),
                            RowItem(label: "Gender", value: "Male"),
                            RowItem(label: "Contact No", value: "824824824"),
                            RowItem(
                                label: "Email",
                                value: "naveenbalajivk@gmail.com"),
                            RowItem(
                              label: "Address",
                              value:
                                  "101/5,000\nCOMPLEX,THONDI ROAD,\nNEAR JEEVA SCHOOL,\nPALLIVASAL NAGAR,\nRAMANATHAPURAM DISTRICT",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  final String label;
  final String value;

  const RowItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.r,
            child: Text(
              "$label:",
              style: TextStyle(fontSize: 12.r),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.black54, fontSize: 12.r),
            ),
          ),
        ],
      ),
    );
  }
}
