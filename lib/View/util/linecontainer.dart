import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:shimmer/shimmer.dart";

import "../../Theme/Colors.dart";

linecontainer(Widget child) {
  return Container(
    decoration: ShapeDecoration(
        color: const Color.fromRGBO(254, 254, 254, 1),
        shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.5, color: greyColor),
            borderRadius: BorderRadius.circular(12.r))),
    child: child,
  );
}

prioritycontainer(
    {required String text,
    required Color backgroundColor,
    required Color textcolor}) {
  return Container(
    decoration: ShapeDecoration(
        color: backgroundColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r))),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 5.r),
      child: Text(text,
          style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                  color: textcolor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.r))),
    ),
  );
}

linecontainerwithshadow(Widget child) {
  return Container(
    decoration: ShapeDecoration(
        shadows: [
          BoxShadow(
            color: blackColor.withOpacity(.11),
            blurRadius: .11,
            offset: const Offset(0, .5),
            spreadRadius: .11,
          )
        ],
        color: whiteColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r))),
    child: child,
  );
}


