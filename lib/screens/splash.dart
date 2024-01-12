import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:canteen/util/const.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';
import 'layout.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  changeScreen() async {
    prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('auth_token');
    String? code = prefs.getString('languageCode');
    final app = Provider.of<AppProvider>(context, listen: false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
      return Layout(
        uid: uid,
      );
    }));
    if (code != null || code != '') {
      app.setPreferredLanguage(code!);
    }
  }
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    changeScreen();
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
              const SizedBox(width: 40.0),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  top: 15.0,
                ),
                child: Text(
                  "${Constants.appName}",
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
