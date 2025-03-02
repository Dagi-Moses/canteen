import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;
  final double height;
  final bool isLoading;
  
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.padding =
        const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 15),
    this.height = 50,required this.isLoading ,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: ElevatedButton(

          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            elevation: 4,
            padding: EdgeInsets.all(5)
            
          ),
        onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? CircularProgressIndicator(
                color: textColor,
                strokeWidth: 2,
              )
              : Text(text),
        ),
      ),
    );
  }
}
