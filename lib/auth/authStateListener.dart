import 'package:canteen/providers/app_provider.dart';
import 'package:canteen/providers/location_provider.dart';
import 'package:canteen/screens/HomeLayout.dart';
import 'package:canteen/screens/join.dart';
import 'package:canteen/screens/language%20screen.dart';
import 'package:canteen/screens/splash.dart';
import 'package:canteen/util/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AuthStateListener extends StatefulWidget {
  @override
  State<AuthStateListener> createState() => _AuthStateListenerState();
}

class _AuthStateListenerState extends State<AuthStateListener> {
  String? uid;
  String? code;
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
 loadPreferences();
  }

  Future<void> loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
      await dotenv.load(); // Load .env file
    final app = Provider.of<AppProvider>(context, listen: false);
   

    uid = prefs.getString('auth_token');
    code = prefs.getString('languageCode');

    List<Future> futures = [
      Future(() => uid),
      Future(() => code),
      Future.delayed(
      Duration.zero), 
    ];
    await Future.wait(futures);

    if (code != null && code!.isNotEmpty) {
      app.setPreferredLanguage(code!);
    }
WidgetsBinding.instance.addPostFrameCallback((_) {
  setState(() {
        isLoading = false;
      });
    });
  
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SplashScreen();
    }
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if ( snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }else if (snapshot.hasData) {
            return HomeLayout();
        } else if (!snapshot.hasData && uid != null) {
          return JoinApp();
        } else {
          return LanguageScreen();
        }
      },
    );
  }
}








// class AuthStateListener extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//      Provider.of<LocationProvider>(context, listen: false);
//     return Consumer<AuthenticationProvider>(
//       builder: (context, auth, child) {
//         if (auth.isLoading) {
//           return SplashScreen();
//         }

//         if (auth.user != null) {
//           return HomeLayout(); // User is signed in
//         } else if ( auth.uid != null) {
//           return JoinApp(); // No Firebase user, but token exists
//         } else {
//           return LanguageScreen(); // No user, no token
//         }
//       },
//     );
//   }
// }
