import 'package:flutter/material.dart';

Widget labeledTextField(
  String labelText,
  TextEditingController controller, {
  bool readOnly = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
      SizedBox(height: 6),
      TextField(
        cursorColor: Colors.red,
        keyboardType: keyboardType,
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
      SizedBox(height: 16),
    ],
  );
}
