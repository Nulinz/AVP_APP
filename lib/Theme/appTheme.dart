import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakthiexports/Theme/Fonts.dart';
import 'Colors.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: primaryMaterialColor,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: whiteColor,
      iconTheme: const IconThemeData(color: blackColor),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryMaterialColor,
          selectionColor: primaryMaterialColor[100],
          selectionHandleColor: primaryMaterialColor),
      elevatedButtonTheme: elevatedButtonThemeData,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          circularTrackColor: whiteColor, color: kPrimaryColor),
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: CircleBorder(),
          backgroundColor: kPrimaryColor,
          foregroundColor: blackColor),
      canvasColor: whiteColor,

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return kPrimaryColor;
          }
          return Colors.grey;
        }),
      ),
      //  inputDecorationTheme: lightInputDecorationTheme,

      checkboxTheme: checkboxThemeData.copyWith(
        overlayColor: const WidgetStatePropertyAll(kPrimaryColor),
        checkColor: const WidgetStatePropertyAll(blackColor),
        side: const BorderSide(color: blackColor40),
        splashRadius: 10,
        visualDensity: VisualDensity.compact,
      ),
      appBarTheme: appBarLightTheme,
      // scrollbarTheme: scrollbarThemeData,
      // dataTableTheme: dataTableLightThemeData,
    );
  }
}

CheckboxThemeData checkboxThemeData = CheckboxThemeData(
  checkColor: WidgetStateProperty.all(Colors.white),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(6),
    ),
  ),
  side: const BorderSide(color: whiteColor40),
);
const AppBarTheme appBarLightTheme = AppBarTheme(
  backgroundColor: Colors.white,
  elevation: 0,
  iconTheme: IconThemeData(color: blackColor),
  titleTextStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: blackColor,
  ),
);

//Button Themes
ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(5),
    backgroundColor: kPrimaryColor,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 32),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  ),
);
ElevatedButtonThemeData elevatedboxButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(10),
    backgroundColor: kPrimaryColor,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 32),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
);

OutlinedButtonThemeData outlinedButtonTheme(
    {Color borderColor = kPrimaryColor}) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(5),
      foregroundColor: textcolor,
      minimumSize: const Size(double.infinity, 32),
      side: BorderSide(width: 1.5, color: borderColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}

final textButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
);

//Form Border Designs
EnabledBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1.5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  );
}

SearchEnabledBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.shade300,
      width: 1.0,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(10),
    ),
  );
}

FocusedBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(
      color: kPrimaryColor,
      width: 2.0,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  );
}

ErrorBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  );
}

FocusedErrorBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 2.0,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  );
}

/// Reusable button widget
buildButton(String text, VoidCallback onPressed) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 50.r),
    child: SizedBox(
      height: 50.r,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.subHeading.copyWith(
            color: whiteColor,
            fontSize: 17.r,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
    ),
  );
}

//Login Flow App theme
AppBar loginflowappBar() {
  return AppBar(
    backgroundColor: backgroundColor,
    surfaceTintColor: backgroundColor,
  );
}

AppBar iconAppBar(
    {Widget? title, bool centerTitle = false, List<Widget>? actions}) {
  return AppBar(
    title: title,
    centerTitle: centerTitle,
    titleTextStyle: GoogleFonts.inter(
      textStyle: TextStyle(
        color: blackColor,
        letterSpacing: .5,
        fontSize: Get.width / 22,
        fontWeight: FontWeight.w600,
      ),
    ),
    surfaceTintColor: backgroundColor,
    backgroundColor: backgroundColor,
    leading: InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        Get.back();
      },
      child: Image.asset(
        "assets/Icons/backarrow.png",
        scale: 3,
      ),
    ),
    actions: actions,
  );
}

AppBar iconAppBarBackgroundless(
    {Widget? title,
    bool centerTitle = false,
    bool implyLeading = true,
    List<Widget>? actions,
    VoidCallback? onPressed,
    Color widgetcolor = blackColor,
    Color appBackgroundColor = Colors.transparent}) {
  return AppBar(
    automaticallyImplyLeading: implyLeading,
    title: title,
    centerTitle: centerTitle,
    titleTextStyle: GoogleFonts.inter(
      textStyle: TextStyle(
        color: widgetcolor,
        letterSpacing: .5,
        fontSize: 17.r,
        fontWeight: FontWeight.w600,
      ),
    ),
    surfaceTintColor: appBackgroundColor,
    backgroundColor: appBackgroundColor,
    leading: implyLeading
        ? InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onPressed ??
                () {
                  Get.back();
                },
            child: Image.asset(
              "assets/Icons/backarrow.png",
              scale: 3,
              color: widgetcolor,
            ),
          )
        : null,
    actions: actions,
  );
}

labelTitle(String labelText) {
  return Text(
    labelText,
    style: TextStyle(
      fontSize: Get.width / 28,
      letterSpacing: .5,
      fontWeight: FontWeight.w600,
      color: blackColor,
    ),
  );
}

defaultProfileAvatar() {
  return Image.asset(
    "assets/Icons/ProfileAvatar.jpg",
    fit: BoxFit.cover,
  );
}

defaultProductAvatar() {
  return Image.asset(
    "assets/Icons/Product-inside.png",
    fit: BoxFit.cover,
  );
}

defaultBrandAvatar() {
  return Image.asset(
    "assets/Icons/Brand_Placeholder.png",
    fit: BoxFit.cover,
  );
}

defaultCategoryAvatar() {
  return Image.asset(
    "assets/Icons/Category_PlaceHolder.png",
    fit: BoxFit.cover,
  );
}
