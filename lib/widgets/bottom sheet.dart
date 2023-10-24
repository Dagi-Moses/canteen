
import 'package:flutter/material.dart';

void displayBottomSheet(BuildContext context, String text) {
  showModalBottomSheet<void>(
    
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    },
  );}