import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



const Color kPrimaryColor = Color.fromRGBO(21, 181, 114, 1);
const Color kBackgroundColor = Color.fromRGBO(7, 17, 26, 1);
const Color kDangerColor = Color.fromRGBO(249, 77, 30, 1);
const Color kCaptionColor = Color.fromRGBO(166, 177, 187, 1);

Color primaryRed = Colors.red;
Color primaryBlack = Colors.black;
Color primaryWhite = Colors.white;
Color linkBlue = Colors.blue;


final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
String uid = firebaseAuth.currentUser!.uid;
FirebaseFirestore firestore = FirebaseFirestore.instance;
 late SharedPreferences prefs;

  final List<String> languageNames = [
  "English",
  "Français",
  "Yorùbá",
  "Igbo",
];
final List<String> languageCodes = [
  "en",
  "fr",
  "yo",
  "ig",
];

// const String serverUrl= "http://192.168.1.118:3000";


const String serverUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';


class Constants {
 
 
//the rest
  static String apiKey = 'sk_live_f113140e0dd9cd86cd6ae6fc117e7da19622f314';

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
    primaryColor: lightPrimary,
    // cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      
       titleTextStyle: 
         TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ), colorScheme: ColorScheme.fromSwatch()
.copyWith(secondary: lightAccent).copyWith(surface: lightBG),
//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
    
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    
    scaffoldBackgroundColor: darkBG,
    //cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ), colorScheme: ColorScheme.dark(
    primary: darkPrimary,
    secondary: darkAccent,
  ).copyWith(surface: darkBG),
//      iconTheme: IconThemeData(
//        color: darkAccent,
//      ),
    
  );
}




class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}