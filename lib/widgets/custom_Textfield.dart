

import 'package:canteen/util/fadeAnimation.dart';
import 'package:flutter/material.dart';


class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool ispassword;
   final IconData prefixIcon;
final String? Function(String?)? validator;

  final double width;
  
 

 

  CustomTextFormField({
    Key? key,
    
    required this.controller,
    required this.labelText,
        this.ispassword = false,
     required this.prefixIcon, 
this.validator, 
 this.width = 600,

    

    
    
    // Control for obscuring text
  })  :
       
       
        super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
   late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.ispassword; // Initialize obscure with ispassword value
  }
  @override
  Widget build(BuildContext context) {
    
    return Card(
    
      elevation: 3.0,
      child: Container(
         
          
            decoration: BoxDecoration(
              color: Colors.white,
              
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: TextFormField(
              validator:widget.validator,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                labelText: widget.labelText,
                labelStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                   suffixIcon: widget.ispassword? GestureDetector(
                    onTap: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    child: obscure
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off)): null,
                prefixIcon: Icon(
                 widget.prefixIcon,
                  color: Colors.black,
                ),
              ),
                  obscureText: obscure,
              maxLines: 1,
              controller: widget.controller,
            ),
          ),
        
      
    );
  }
}

 
 
 
 