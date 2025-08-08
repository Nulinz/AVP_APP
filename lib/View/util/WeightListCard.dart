import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:avpsiddhacademy/Theme/Colors.dart';
import 'package:avpsiddhacademy/Theme/Fonts.dart';

class Weightlistcard extends StatelessWidget {
  final List<String> weightOptions;
  final RxString selectedQuantity;
  final ValueChanged<String> onWeightSelected; // Add this line

  const Weightlistcard({
    super.key,
    required this.weightOptions,
    required this.selectedQuantity,
    required this.onWeightSelected, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.r,
      width: Get.width / 1,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 5,
          children: weightOptions.map((option) {
            return Obx(() => ChoiceChip(
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    option,
                    style: AppTextStyles.small.bold.copyWith(
                      color: selectedQuantity.value == option
                          ? Colors.white
                          : blackColor,
                    ),
                  ),
                  selected: selectedQuantity.value == option,
                  onSelected: (isSelected) {
                    // selectedQuantity.value =
                    // isSelected ? option : "Select Quantity";
                    selectedQuantity.value = option;
                    onWeightSelected(option);
                  },
                  selectedColor: kPrimaryColor,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ));
          }).toList(),
        ),
      ),
    );
  }
}
