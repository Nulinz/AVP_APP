import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../Theme/Colors.dart';

class ShimmerPostCard extends StatelessWidget {
  final int count;
  final bool showFollowButton;
  const ShimmerPostCard(
      {super.key, required this.count, this.showFollowButton = true});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: whiteColor,
              child: const Stack(children: []));
        });
  }
}
