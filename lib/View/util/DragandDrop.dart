import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:get/get.dart';

// class DragTargetsRow extends StatefulWidget {
//   final int draggedTask;

//   final Function(String task) onDropInProgress;
//   final Function(String task) onDropOnHold;
//   final Function(String task) onDropCompleted;

//   const DragTargetsRow({
//     super.key,
//     required this.draggedTask,
//     required this.onDropInProgress,
//     required this.onDropOnHold,
//     required this.onDropCompleted,
//   });

//   @override
//   State<DragTargetsRow> createState() => _DragTargetsRowState();
// }

// class _DragTargetsRowState extends State<DragTargetsRow>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration:
//           const Duration(milliseconds: 600), // Longer duration for smoothness
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.elasticOut,
//       ),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.2, 1.0,
//             curve: Curves.easeOut), // Adds delay to fade-in
//       ),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.2, 1.0,
//             curve: Curves.easeOut), // Adds delay to fade-in
//       ),
//     );
//   }

//   @override
//   void didUpdateWidget(covariant DragTargetsRow oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.draggedTask != 0) {
//       _controller.forward(
//           from: 0); // Restart animation when `draggedTask` changes
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.draggedTask == 0
//         ? const SizedBox()
//         : FadeTransition(
//             opacity: _fadeAnimation,
//             child: ScaleTransition(
//               scale: _scaleAnimation,
//               child: Column(
//                 children: [
//                   Container(
//                     color: Colors.white.withOpacity(.1),
//                     width: MediaQuery.sizeOf(context).width,
//                     height: 270.r,
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         CustomPaint(
//                           size: Size(MediaQuery.sizeOf(context).width, 300),
//                           painter: ArcPainter(),
//                         ),
//                         Positioned(
//                           bottom: 20.r,
//                           child: Container(
//                             width: 100.r,
//                             height: 100.r,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFFA18EFF), Color(0xFF836FFF)],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black26,
//                                   blurRadius: 10.r,
//                                   offset: Offset(0, 5.r),
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Drag & Drop',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14.r,
//                                   fontWeight: FontWeight.bold,
//                                   shadows: [
//                                     Shadow(
//                                       offset: Offset(1.r, 1.r),
//                                       blurRadius: 3.r,
//                                       color: Colors.black26,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: ArcWidgets(
//                             radius: Get.width / 2.2 + 5,
//                             widgets: [
//                               // DragTarget<String>(
//                               //   onAccept: widget.onDropTodo,
//                               //   builder:
//                               //       (context, candidateData, rejectedData) {
//                               //     return DragOption(
//                               //       title: 'Todo',
//                               //       isHighlighted: candidateData.isNotEmpty,
//                               //     );
//                               //   },
//                               // ),
//                               DragTarget<String>(
//                                 onAcceptWithDetails: widget.onDropInProgress,
//                                 builder:
//                                     (context, candidateData, rejectedData) {
//                                   return DragOption(
//                                     title: 'In Progress',
//                                     isHighlighted: candidateData.isNotEmpty,
//                                   );
//                                 },
//                               ),
//                               DragTarget<String>(
//                                 onAcceptWithDetails: widget.onDropOnHold,
//                                 builder:
//                                     (context, candidateData, rejectedData) {
//                                   return DragOption(
//                                     title: 'On Hold',
//                                     isHighlighted: candidateData.isNotEmpty,
//                                   );
//                                 },
//                               ),
//                               DragTarget<String>(
//                                 onAcceptWithDetails: widget.onDropCompleted,
//                                 builder:
//                                     (context, candidateData, rejectedData) {
//                                   return DragOption(
//                                     title: 'Completed',
//                                     isHighlighted: candidateData.isNotEmpty,
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }
// }

class DragOption extends StatelessWidget {
  final String title;
  final bool isHighlighted;

  const DragOption({
    super.key,
    required this.title,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 45.r,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsets.symmetric(vertical: 5.r),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.blue[200] : null,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          if (isHighlighted)
            BoxShadow(
              color: const Color(0xFFA18EFF).withOpacity(0.5),
              blurRadius: 10.r,
              spreadRadius: 1.r,
            ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.r,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class ArcWidgets extends StatelessWidget {
  final List<Widget> widgets;
  final double radius;
  final double separatorThickness; // Thickness of the separator
  final double separatorLength; // Length of the separator
  final Color separatorColor; // Color of the separator

  const ArcWidgets({super.key, 
    required this.widgets,
    required this.radius,
    this.separatorThickness = 2.0,
    this.separatorLength = 40.0,
    this.separatorColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(.1),
      width: Get.width,
      height: radius,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(widgets.length * 2 - 1, (index) {
          print(Get.width);
          const double totalAngle = pi;
          // Positioning for Widgets from second index
          final double anglePerWidget =
              totalAngle / (widgets.length + Get.width / 350.r);

          // Handle positioning for widgets and separators
          if (index.isEven) {
            // Positioning for widgets from first index
            final double widgetAngle =
                pi + (index ~/ 2 * anglePerWidget + Get.width / 500.r);
            final double x = radius + radius * cos(widgetAngle);
            final double y = radius + radius * sin(widgetAngle);

            return Positioned(
              left: x - 40.r,
              //(Get.width / 1 < 400 ? Get.width / 10 : Get.width / 12),
              top: y - 5.r,
              child: Transform.rotate(
                angle: widgetAngle + pi / 2.05,
                child: SizedBox(width: 110.r, child: widgets[index ~/ 2]),
              ),
            );
          } else {
            // Positioning for separators
            final double separatorAngle = pi +
                ((index - 1) ~/ 2 * anglePerWidget + Get.width / 500.r) +
                anglePerWidget / 2.r;
            final double x = radius - 6 + radius * cos(separatorAngle);
            final double y = radius + radius * sin(separatorAngle);

            return Positioned(
              left: x - separatorLength / 5.w,
              top: y - separatorThickness + 18.h,
              child: Transform.rotate(
                angle: separatorAngle + pi,
                child: Container(
                  width: separatorLength,
                  height: separatorThickness,
                  color: separatorColor,
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = Get.width / 6
      ..strokeCap = StrokeCap.butt
      ..color = Colors.grey.shade300.withOpacity(.7);

    Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height),
      radius: size.width / 2,
    );

    canvas.drawArc((rect), 3.55, pi / 1.35, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
