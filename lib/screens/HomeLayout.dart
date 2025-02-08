import 'package:canteen/admin/screens/dashboard.dart';
import 'package:canteen/screens/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import '../util/const.dart';
import 'main_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class HomeLayout extends StatefulWidget {
  HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
        final app = AppLocalizations.of(context)!;
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for data
          return SplashScreen();
        }

        if (snapshot.hasError) {
          // Handle error case if snapshot has error
          print('Error: ${snapshot.error}');
          return Scaffold(body: Center(child: Text('${app.error}: ${snapshot.error}', style: TextStyle(color: Colors.red),)));
        }

        // Handle null data gracefully
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data?.data() == null) {
          // Handle the case where the data is null
           return Scaffold(
               body: Center(
                   child: Text(
                      app.noUserData,
                       style: TextStyle(color: Colors.red),
                     )));
        }

        Map<String, dynamic>? userData =
            snapshot.data?.data() as Map<String, dynamic>?;

        // Make sure userData is not null before passing to the provider
        if (userData != null) {
          Provider.of<UserProvider>(context, listen: false)
              .setUserFromSnapshot(userData);
        }

        // Check if the current user is admin or regular user
        if (uid == Constants.admin) {
          return const DashBoard(); // Navigate to Dashboard if admin
        } else {
          return MainScreen(); // Navigate to MainScreen for regular users
        }
      },
    );
  }
}


