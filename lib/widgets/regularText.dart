import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final double? letterSpacing;
  final TextAlign? textAlign;

  const CustomText({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.letterSpacing,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 16.0, // Default font size
        fontWeight: fontWeight ?? FontWeight.w100, // Default font weight
        color: color ?? Colors.black87, // Default color
        letterSpacing: letterSpacing ?? 1.2, // Default letter spacing
      ),
      textAlign: textAlign ?? TextAlign.center, // Default text alignment
    );
  }
}

