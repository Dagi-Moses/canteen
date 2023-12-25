import 'package:flutter/material.dart';


import 'package:flutter/services.dart';


import 'package:canteen/util/const.dart';


import 'package:shared_preferences/shared_preferences.dart';


class AppProvider extends ChangeNotifier {
  

  Locale _preferredLocale = Locale('en');


  Locale get preferredLocale => _preferredLocale; // Default to English


  int _selectedLanguageIndex = 0; // Assume 0 is the default index


  int get selectedLanguageIndex => _selectedLanguageIndex;


  void setPreferredLanguage(String languageCode) {


    _preferredLocale = Locale(languageCode);

    prefs.setString('languageCode', languageCode);

    if (languageCode == 'en') {

      _selectedLanguageIndex = 0;

    } else if (languageCode == 'fr') {

      _selectedLanguageIndex = 1;

    } else if (languageCode == 'yo') {

      _selectedLanguageIndex = 2;

    } else {

      _selectedLanguageIndex = 3;

    }


    notifyListeners();

  }


  AppProvider() {

    checkTheme();

  }


  ThemeData theme = Constants.lightTheme;


  Key key = UniqueKey();


  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  void setKey(value) {

    key = value;


    notifyListeners();

  }


  void setNavigatorKey(value) {

    navigatorKey = value;


    notifyListeners();

  }


  void setTheme(value, c) {

    theme = value;


    SharedPreferences.getInstance().then((prefs) {

      prefs.setString("theme", c).then((val) {

        //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);


        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,

            overlays: [SystemUiOverlay.top]);


        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(

          statusBarColor:

              c == "dark" ? Constants.darkPrimary : Constants.lightPrimary,

          statusBarIconBrightness:

              c == "dark" ? Brightness.light : Brightness.dark,

        ));

      });

    });


    notifyListeners();

  }


  ThemeData getTheme(value) {

    return theme;

  }


  Future<ThemeData> checkTheme() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();


    ThemeData t;


    String r =

        prefs.getString("theme") == null ? "light" : prefs.getString("theme")!;


    if (r == "light") {

      t = Constants.lightTheme;


      setTheme(Constants.lightTheme, "light");

    } else {

      t = Constants.darkTheme;


      setTheme(Constants.darkTheme, "dark");

    }


    return t;

  }

}

