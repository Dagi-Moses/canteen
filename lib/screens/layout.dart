import 'package:canteen/screens/main_screen.dart';
import 'package:canteen/screens/walkthrough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../admin/screens/home_screen.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.uid == 'S6hMPwvFmWc08JfLMhwEScXd5p23') {
            return HomeScreen();
          } else {
            return MainScreen();
          }
        } else {
          return Walkthrough();
        }
      },
    );
  }
}
