
// import 'package:flutter/material.dart';


// import '../../models/order request.dart';
// import '../screens/order_details_screen.dart';

// class OrderCardDesign extends StatelessWidget {
//   final OrderRequestModel model;

//   const OrderCardDesign({Key? key, required this.model}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: ((context) => OrderDetailsScreen(orderID: model.menuID)),
//           ),
//         );
//       },
//       child: Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(
//             Radius.circular(5),
//           ),
//           gradient: LinearGradient(
//             begin: FractionalOffset(0.0, 0.0),
//             end: FractionalOffset(3.0, -1.0),
//             colors: [
//               Colors.black54,
//               Colors.white54,
//             ],
//           ),
//         ),
//         padding: const EdgeInsets.all(4),
//         margin: const EdgeInsets.all(8),
//         height: model.itemCount! * 125,
//         child: ListView.builder(
//           itemCount: model.itemCount,
//           physics: const NeverScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
//             return placedOrderDesignWidget(
//               model,
//               context,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// Widget placedOrderDesignWidget(
//   OrderRequestModel model,
//   BuildContext context,
// ) {
//   return Container(
//     width: MediaQuery.of(context).size.width,
//     height: 120,
//     color: Colors.grey[200],
//     child: Row(children: [
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color(0xff7c94b6),
//             border: Border.all(
//               color: Colors.black,
//               width: 2,
//             ),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.network(
//               model.thumbnailUrl!,
//               width: 120,
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(width: 10),
//       Expanded(
//           child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 20),

//           Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Expanded(
//                 child: Text(
//                   model.menuTitle,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontFamily: "Acme",
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               const Text(
//                 "\$ ",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.blue,
//                 ),
//               ),
//               Text(
//                 model.menuPrice.toString() + "   ",
//                 style: const TextStyle(
//                   color: Colors.blue,
//                   fontSize: 18,
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 20),
//           //total number
//           Row(
//             children: [
//               const Text(
//                 "x ",
//                 style: TextStyle(
//                   color: Colors.black54,
//                   fontSize: 14,
//                 ),
//               ),
//               Expanded(
//                   child: Text(
//                 'seperateQuantitiesList',
//                 style: const TextStyle(
//                   color: Colors.black54,
//                   fontSize: 30,
//                   fontFamily: "Acme",
//                 ),
//               ))
//             ],
//           )
//         ],
//       ))
//     ]),
//   );
// }
