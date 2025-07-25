import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Theme/Colors.dart';

DetailsFillupPopup(
    BuildContext context,
    String Title,
    String Subtitle,
    String primaryButton,
    VoidCallback onPressed,
    WillPopCallback? willpopScreen) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: willpopScreen,
        child: AlertDialog(
          backgroundColor: whiteColor,
          title: Column(
            children: [
              Image.asset("assets/Images/DetailsFillPopup.jpg"),
              Text(Title,
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    color: blackColor,
                    fontSize: Get.width / 22,
                    fontWeight: FontWeight.w700,
                  ))),
            ],
          ),
          content: Text(
            Subtitle,
            style: const TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            SizedBox(
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(kPrimaryColor)),
                onPressed: onPressed,
                child: Text(primaryButton, style: const TextStyle(color: blackColor)),
              ),
            )
          ],
        ),
      );
    },
  );
}

OutofStockConfirmationsPopup(
    BuildContext context,
    String Title,
    String Subtitle,
    String primaryButton,
    VoidCallback onPressed,
    WillPopCallback? willpopScreen) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: willpopScreen,
        child: AlertDialog(
          backgroundColor: whiteColor,
          title: Column(
            children: [
              Text(Title,
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    color: blackColor,
                    fontSize: Get.width / 22,
                    fontWeight: FontWeight.w700,
                  ))),
            ],
          ),
          content: Text(
            Subtitle,
            style: const TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: Get.width / 4,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(greyColor)),
                      onPressed: () => Get.back(),
                      child: const Text("Cancel")),
                ),
                SizedBox(
                  width: Get.width / 4,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(kPrimaryColor)),
                    onPressed: onPressed,
                    child: Text(
                      primaryButton,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    },
  );
}

ConfirmationsPopup(
    BuildContext context,
    String Title,
    String Subtitle,
    String primaryButton,
    Color primaryButtoncolor,
    VoidCallback onPressed,
    WillPopCallback? willpopScreen) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: willpopScreen,
        child: AlertDialog(
          backgroundColor: whiteColor,
          title: Column(
            children: [
              Text(Title,
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    color: blackColor,
                    fontSize: Get.width / 22,
                    fontWeight: FontWeight.w700,
                  ))),
            ],
          ),
          content: Text(
            Subtitle,
            style: const TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: Get.width / 4,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(greyColor)),
                      onPressed: () => Get.back(),
                      child: const Text("Back")),
                ),
                SizedBox(
                  width: Get.width / 3,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(primaryButtoncolor)),
                    onPressed: onPressed,
                    child: Text(
                      primaryButton,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    },
  );
}

successPopup(
    BuildContext context,
    String Title,
    String Subtitle,
    String primaryButton,
    VoidCallback onPressed,
    WillPopCallback? willpopScreen) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: willpopScreen,
        child: AlertDialog(
          backgroundColor: whiteColor,
          title: Column(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: kPrimaryColor,
                size: Get.width / 8,
              ),
              Text(
                Title,
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            Subtitle,
            style: const TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: onPressed,
              child: Text(
                primaryButton,
              ),
            )
          ],
        ),
      );
    },
  );
}

ApplicationsuccessPopup(
    BuildContext context,
    String Title,
    String Subtitle,
    String primaryButton,
    VoidCallback onPressed,
    WillPopCallback? willpopScreen) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: willpopScreen,
        child: AlertDialog(
          backgroundColor: whiteColor,
          title: Column(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: kPrimaryColor,
                size: Get.width / 6,
              ),
              const SizedBox(height: 10),
              Text(
                Title,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: Get.width / 26),
              ),
            ],
          ),
          content: Text(
            Subtitle,
            style: const TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: onPressed,
              child: Text(
                primaryButton,
              ),
            )
          ],
        ),
      );
    },
  );
}

SigninLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          Get.back();
          return true;
        },
        child: AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: Get.height / 6,
            width: Get.width / 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width,
                    height: Get.height / 6,
                    child: Image.asset(
                      "assets/Icons/google loader.gif",
                      fit: BoxFit.cover,
                    ),
                  ),
                  // SizedBox(height: Get.width / 20),
                  // Text("Processing...",
                  //     style: GoogleFonts.poppins(
                  //         textStyle: TextStyle(
                  //       color: BlackColor,
                  //       fontSize: Get.width / 26,
                  //       fontWeight: FontWeight.w500,
                  //     ))),
                  // Text("Please wait Don't Go Back",
                  //     style: GoogleFonts.poppins(
                  //         textStyle: TextStyle(
                  //       color: yellowcolor,
                  //       fontSize: Get.width / 26,
                  //       fontWeight: FontWeight.w600,
                  //     )))
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
