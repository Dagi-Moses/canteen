import 'package:flutter/material.dart';
class TextInput extends StatefulWidget {
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextEditingController controller;
  final String hintText;
  TextInput({super.key, this.hintText = '', required this.controller, this.obscureText = false, this.validator, required this.icon});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Card(
              elevation: 3.0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                  validator: widget.validator,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: widget.hintText,
                    suffix: null,
                    suffixIcon:widget.obscureText? GestureDetector(
                    onTap:(){
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    child: obscure? const Icon( Icons.visibility_off) : const Icon( Icons.visibility)) : null,
                    prefixIcon: Icon(
                      widget.icon,
                      color: Colors.black,
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  obscureText: widget.obscureText ? obscure :false,
                  maxLines: 1,
                  controller: widget.controller,
                ),
              ),
            );
  }
}