

import 'package:canteen/util/const.dart';

import 'package:flutter/material.dart';

import 'HomeLayout.dart';
import 'language screen.dart';

class Layout extends StatefulWidget {
  final String ? uid;
  Layout({super.key, required this.uid});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
 String? code = prefs.getString('languageCode');
  @override
  Widget build(BuildContext context) {
    if (widget.uid == null || widget.uid!.isEmpty || widget.uid == '' || code == null || code == '') {
     return LanguageScreen();
    } else {
        return HomeLayout(
        uid: widget.uid,
      );
    }
  }
}
