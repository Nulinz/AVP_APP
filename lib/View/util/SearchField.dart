import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../Theme/Colors.dart';
import '../../Theme/appTheme.dart';

class Searchfield extends StatelessWidget {
  final void Function(String) onChanged;

  const Searchfield({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      autocorrect: true,
      style: const TextStyle(color: Colors.black87),
      cursorColor: Colors.black54,
      decoration: InputDecoration(
        hintText: "Search ",
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        hintStyle: TextStyle(
          color: greyColor80,
          fontSize: 16.r,
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: FocusedBorder(),
        enabledBorder: SearchEnabledBorder(),
        prefixIcon: const Icon(
          Iconsax.search_normal_1,
          color: blackColor80,
        ),
        filled: true,
        fillColor: whiteColor,
      ),
    );
  }
}
