import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final double letterSpacing;
  final TextAlign textAlign;

  const CustomText({
    Key? key,
    required this.text,
    this.fontSize = 16.0, // Default font size
    this.fontWeight = FontWeight.w100, // Default font weight
    this.color = Colors.black87, // Default color
    this.letterSpacing = 1.2, // Default letter spacing
    this.textAlign = TextAlign.center, // Default text alignment
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
    );
  }
}
