import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../admin/screens/home_screen.dart';
import '../providers/provider.dart';
import '../util/const.dart';
import 'main_screen.dart';

class HomeLayout extends StatefulWidget {
  String ? uid;
  HomeLayout({super.key, required this.uid});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        Map<String, dynamic>? userData =
            snapshot.data?.data() as Map<String, dynamic>?;

        Provider.of<UserProvider>(context, listen: false)
            .setUserFromSnapshot(userData ?? {});

        if (widget.uid == Constants.admin) {
          return const HomeScreen();
        } else {
          return MainScreen();
        }
      },
    );
  }
}
