// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// filePickingInput() {
//   return Container(
//     height: 18.r,
//     decoration: BoxDecoration(
//         color: LightGreyColor, borderRadius: BorderRadius.circular(3)),
//     child: Row(
//       children: [
//         SizedBox(
//           height: MediaQuery.sizeOf(context).height / 16,
//           width: MediaQuery.sizeOf(context).width / 4.1,
//           child: TextButton(
//             style: ButtonStyle(
//               foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//               backgroundColor: WidgetStateProperty.all<Color>(lightgreen),
//               shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                   RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               )),
//             ),
//             onPressed: _pickFile,
//             child: Text(
//               "Choose File",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: MediaQuery.sizeOf(context).width / 32,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         fileNames.isNotEmpty
//             ? Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 5),
//                 child: SizedBox(
//                   width: screenWidth / 2,
//                   child: Text(
//                     fileNames.length == 1
//                         ? '${fileNames.length} File Added'
//                         : '${fileNames.length} Files Added',
//                     style: TextStyle(
//                       fontSize: screenWidth / 25,
//                     ),
//                     textAlign: TextAlign.center,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               )
//             : Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: Text(
//                   'No Files Added',
//                   style: TextStyle(
//                     fontSize: screenWidth / 25,
//                   ),
//                   textAlign: TextAlign.center,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               )
//       ],
//     ),
//   );
// }
