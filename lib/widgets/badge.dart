import 'package:flutter/material.dart';


class IconBadge extends StatelessWidget {

  final IconData icon;
  final double size;
  final int data;

  IconBadge({ Key ?key, required this.icon, this.size = 24, required this.data})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: <Widget>[
        Icon(
          icon,
          size: size,
        ),
        Positioned(
          right: 0.0,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 13,
              minHeight: 13,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 1),
              child:Text(
               data.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
