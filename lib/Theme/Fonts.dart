import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakthiexports/Theme/Colors.dart';

class AppTextStyles {
  // NotoSans Font Styles (Arial alternative)
  static TextStyle heading = _notoSansStyle(24.r, FontWeight.bold, textcolor);
  static TextStyle subHeading =
      _notoSansStyle(21.r, FontWeight.w600, kPrimaryColor);
  static TextStyle body =
      _notoSansStyle(17.r, FontWeight.normal, kPrimaryColor);
  static TextStyle small = _notoSansStyle(14.r, FontWeight.normal, whiteColor);
  static TextStyle error = _notoSansStyle(15.r, FontWeight.bold, Colors.red);
  static TextStyle success =
      _notoSansStyle(15.r, FontWeight.bold, Colors.green);

  // LuckiestGuy Font Styles
  static TextStyle headingLuckiest = _luckiestGuyStyle(
    24.r,
    FontWeight.bold,
    textcolor,
  );
  static TextStyle subHeadingLuckiest =
      _luckiestGuyStyle(21.r, FontWeight.w600, textcolor);
  static TextStyle bodyLuckiest =
      _luckiestGuyStyle(17.r, FontWeight.normal, textcolor);
  static TextStyle smallLuckiest =
      _luckiestGuyStyle(14.r, FontWeight.normal, Colors.black);
  static TextStyle errorLuckiest =
      _luckiestGuyStyle(15.r, FontWeight.bold, Colors.red);
  static TextStyle successLuckiest =
      _luckiestGuyStyle(15.r, FontWeight.bold, Colors.green);

  // Helper method for NotoSans (Arial Alternative)
  static TextStyle _notoSansStyle(double size, FontWeight weight, Color color) {
    return GoogleFonts.notoSans(
      textStyle: TextStyle(
        fontSize: size.r,
        fontWeight: weight,
        height: 1.4.r,
        color: color,
      ),
    );
  }

  // Helper method for LuckiestGuy font
  static TextStyle _luckiestGuyStyle(
      double size, FontWeight weight, Color color) {
    return GoogleFonts.notoSans(
      textStyle: TextStyle(
        fontSize: size.r,
        fontWeight: weight,
        height: 1.4.r,
        color: color,
      ),
    );
  }

  // ✅ Custom Method to Override All Properties
  static TextStyle custom({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    Color color = Colors.black,
    double height = 1.4,
    TextDecoration decoration = TextDecoration.none,
    double letterSpacing = 0,
    bool useLuckiestGuy = false,
  }) {
    return useLuckiestGuy
        ? GoogleFonts.luckiestGuy(
            textStyle: TextStyle(
              fontSize: fontSize.r,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              color: color,
              height: height.r,
              decoration: decoration,
              letterSpacing: letterSpacing.r,
            ),
          )
        : GoogleFonts.notoSans(
            // ← changed here
            textStyle: TextStyle(
              fontSize: fontSize.r,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              color: color,
              height: height.r,
              decoration: decoration,
              letterSpacing: letterSpacing.r,
            ),
          );
  }
}

// ✅ Extension for Quick Style Modifications
extension TextStyleModifiers on TextStyle {
  TextStyle withColor(Color customColor) => copyWith(color: customColor);
  TextStyle withSize(double customSize) => copyWith(fontSize: customSize.r);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get strikeThrough =>
      copyWith(decoration: TextDecoration.lineThrough);
}
