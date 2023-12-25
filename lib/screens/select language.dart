import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../util/const.dart';

class SelectLanguge extends StatefulWidget {
  const SelectLanguge({super.key});

  @override
  State<SelectLanguge> createState() => _SelectLangugeState();
}

class _SelectLangugeState extends State<SelectLanguge>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward();
    animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    Timer(Duration(seconds: 3), () {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final app = AppLocalizations.of(context)!;
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(
              child: Icon(
                Icons.fastfood,
                size: 150.0,
                color: Colors.red,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              top: 15.0,
            ),
            child: Text(
              "${Constants.appName}",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
