
import 'package:canteen/providers/location_provider.dart';
import 'package:canteen/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:canteen/util/const.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? uid;
  String? code;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    loadPreferencesAndNavigate();
  }
void loadPreferencesAndNavigate() async {
     prefs = await SharedPreferences.getInstance();
    final app = Provider.of<AppProvider>(context, listen: false);
    final location = Provider.of<LocationProvider>(context, listen: false);

    List<Future> futures = [
      Future(() => uid = prefs.getString('auth_token')),
      Future(() => code = prefs.getString('languageCode')),
      Future.delayed(const Duration(seconds: 1)), // Simulate loading time
    ];
    await Future.wait(futures);
    
    if (uid == null || uid!.isEmpty) {
    Navigator.pushReplacementNamed(context, Routes.language);

    } else {
     Navigator.pushReplacementNamed(context, Routes.homeLayout, arguments: uid);

    }
    if (code != null && code!.isNotEmpty) {
      app.setPreferredLanguage(code!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(left: 40.0, right: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.fastfood,
                size: 150.0,
                color: Colors.red,
              ),
              const SizedBox(height: 40.0),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 15.0),
                child: Text(
                  Constants.appName,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
