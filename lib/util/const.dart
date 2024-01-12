import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:shared_preferences/shared_preferences.dart';




final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
String uid = firebaseAuth.currentUser!.uid;
FirebaseFirestore firestore = FirebaseFirestore.instance;
 late SharedPreferences prefs;
class Constants {
 

//the rest
  static String apiKey = 'sk_live_f113140e0dd9cd86cd6ae6fc117e7da19622f314';
  static String appName = "Noel's Canteen";
  static String admin = '1UuGd7EeZFcYZZmmvpYgWevOcGH3';

  //Colors for theme
//  Color(0xfffcfcff);
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.red;
  static Color darkAccent = Colors.red[400]!;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color ratingBG = Colors.yellow[600]!;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    colorScheme:  ColorScheme.fromSwatch()
.copyWith(secondary: lightAccent),
    // cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      
       titleTextStyle: 
         TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
    
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
     colorScheme: ColorScheme.dark(
    primary: darkPrimary,
    secondary: darkAccent,
  ),
    
    scaffoldBackgroundColor: darkBG,
    //cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: darkAccent,
//      ),
    
  );
}
