import 'package:canteen/providers/app_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoardWidget extends StatefulWidget {
  final int index;
  final Map<String, dynamic> cat;

  DashBoardWidget({
    super.key,
    required this.index,
    required this.cat,
  });

  @override
  State<DashBoardWidget> createState() => _DashBoardWidgetState();
}

class _DashBoardWidgetState extends State<DashBoardWidget> {
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: ((context) {
          return widget.cat['nav'];
        })));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 138, 32, 32),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ]),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.cat['icon'],
                color: Colors.white,
                size: 20,
              ),
              SizedBox(
                height: 5,
              ),
              Text(widget.cat['name'], style: TextStyle(color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}
