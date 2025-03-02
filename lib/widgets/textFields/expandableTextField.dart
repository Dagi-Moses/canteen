import 'package:flutter/material.dart';

class ExpandableTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final String hintText;

  const ExpandableTextField({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.hintText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        elevation: 6.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
          constraints: BoxConstraints(
            maxWidth: focusNode.hasFocus ? 300 : 150, // Expand to 600 when focused
          ),
          child: TextField(
            onSubmitted: (v) {
            focusNode.unfocus();
            },
            focusNode: focusNode,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintText: hintText,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintStyle: const TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            controller: controller,
          ),
        ),
      ),
    );
  }
}
