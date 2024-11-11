import 'package:flutter/material.dart';


class ScreenHelper extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  ScreenHelper(
      {Key? key,
      required this.desktop,
      required this.mobile,
      required this.tablet})
      : super(key: key);

  // Detect if it's a mobile device by width and aspect ratio
  static bool isMobile(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return width < 800.0 &&
        aspectRatio > 1.6; // Higher aspect ratios are more typical of phones
  }

  // Detect if it's a tablet by width and aspect ratio
  static bool isTablet(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return width >= 800.0 &&
        width < 1200.0 &&
        aspectRatio <= 1.6; // Tablets often have wider aspect ratios
  }

  // Detect if it's a desktop by width only
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200.0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var aspectRatio = constraints.maxWidth / constraints.maxHeight;

        if (constraints.maxWidth >= 1200.0) {
          // Desktop layout
          return desktop;
        } else if (constraints.maxWidth >= 800.0 &&
            constraints.maxWidth < 1200.0) {
          // Tablet layout considering aspect ratio
          if (aspectRatio < 1.6) {
            return tablet; // Typical wider tablet aspect ratio
          } else {
            return mobile; // Treat this as mobile layout due to the narrower aspect ratio
          }
        } else {
          // Mobile layout
          return mobile;
        }
      },
    );
  }
}



// class ScreenHelper extends StatelessWidget {
//   final Widget mobile;
//   final Widget tablet;
//   final Widget desktop;

//   ScreenHelper({Key? key, required this.desktop, required this.mobile, required this.tablet})
//       : super(key: key);

//   static bool isMobile(BuildContext context) =>
//       MediaQuery.of(context).size.width < 800.0;

//   static bool isTablet(BuildContext context) =>
//       MediaQuery.of(context).size.width >= 800.0 &&
//       MediaQuery.of(context).size.width < 1200.0;

//   static bool isDesktop(BuildContext context) =>
//       MediaQuery.of(context).size.width >= 1200.0;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         if (constraints.maxWidth >= 1200.0) {
//           return desktop;
//         } else if (constraints.maxWidth >= 800 &&
//             constraints.maxWidth < 1200.0) {
//           return tablet;
//         } else {
//           return mobile;
//         }
//       },
//     );
//   }
// }
