

import 'package:canteen/providers/location_provider.dart';
import 'package:canteen/screens/HomeLayout.dart';
import 'package:canteen/screens/join.dart';
import 'package:canteen/screens/language%20screen.dart';
import 'package:canteen/screens/splash.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';





class AuthStateListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     Provider.of<LocationProvider>(context, listen: false);
    return Consumer<AuthenticationProvider>(
      builder: (context, auth, child) {
        if (auth.isLoading) {
          return SplashScreen();
        }

        if (auth.user != null) {
          return HomeLayout(); // User is signed in
        } else if (auth.uid != null) {
          return JoinApp(); // No Firebase user, but token exists
        } else {
          return LanguageScreen(); // No user, no token
        }
      },
    );
  }
}


// class AuthStateListener extends StatefulWidget {
//   @override
//   State<AuthStateListener> createState() => _AuthStateListenerState();
// }

// class _AuthStateListenerState extends State<AuthStateListener> {
//   String? uid;
//   String? code;
//   bool isLoading = true; // Track if preferences are still loading

//   @override
//   void initState() {
//     super.initState();
//  loadPreferences().then((_) {
//       FirebaseAuth.instance.authStateChanges().listen((_) {
//         setState(() {}); // Ensure rebuild on auth state change
//       });
//     });
//   }

//   Future<void> loadPreferences() async {
//     prefs = await SharedPreferences.getInstance();
//     final app = Provider.of<AppProvider>(context, listen: false);
//     final location = Provider.of<LocationProvider>(context, listen: false);

//     // Simulate loading preferences
//     uid = prefs.getString('auth_token');
//     code = prefs.getString('languageCode');

//     List<Future> futures = [
//       Future(() => uid),
//       Future(() => code),
//       Future.delayed(
//           const Duration(seconds: 1)), // Minimum delay of 1 second for splash
//     ];
//     await Future.wait(futures);

//     if (code != null && code!.isNotEmpty) {
//       app.setPreferredLanguage(code!);
//     }

//     setState(() {
//       isLoading = false; // Preferences are loaded, update UI
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     if (isLoading) {
//       return SplashScreen();
//     }
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//        //User? user = snapshot.data;
//         if ( snapshot.connectionState == ConnectionState.waiting) {
//           // Show splash screen while loading preferences or waiting for Firebase state
//           return SplashScreen();
//         }else if (snapshot.hasData) {
//             // User is signed in
//             return HomeLayout();
          
//         } else if (!snapshot.hasData && uid != null) {
//           // No user is signed in but token exists
//           return JoinApp();
//         } else {
//           // No user signed in and no token
//           return LanguageScreen();
//         }
//       },
//     );
//   }
// }



