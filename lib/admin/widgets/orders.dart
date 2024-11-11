// // ignore_for_file: must_be_immutable

// import 'package:canteen/models/order%20request.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:canteen/models/menus.dart';
// import 'package:intl/intl.dart';

// import '../../util/firebase functions.dart';
// import '../screens/item_detail_screen.dart';

// class OrdersWidget extends StatefulWidget {
//    OrderRequestModel? model;
//   BuildContext? context;

//   OrdersWidget({Key? key, this.context, this.model}) : super(key: key);

//   @override
//   _OrdersWidgetState createState() => _OrdersWidgetState();
// }

// class _OrdersWidgetState extends State<OrdersWidget> {
 

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.grey,
//             blurRadius: 3,
//             offset: Offset(1, 1),
//           )
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: SizedBox(
//           height: 100,
//           width: double.infinity,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.network(
//                   widget.model!.thumbnailUrl!,
//                   width: 100,
//                   height: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(width: 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.model!.menuTitle,
//                       style: GoogleFonts.lato(
//                         textStyle: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
                    
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         RichText(
//                           text: TextSpan(
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF424242),
//                             ),
//                             children: [
//                               const TextSpan(text: r"₦"),
//                               TextSpan(
//                                 text: widget.model!.menuPrice.toString(),
//                                 style: GoogleFonts.lato(
//                                   textStyle: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey[800],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           DateFormat('dd/MM/yy')
//                               .format(widget.model!.orderDate),
//                           style: GoogleFonts.lato(
//                             textStyle: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
