import 'package:canteen/providers/app_provider.dart';
import 'package:canteen/util/const.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {



  
final AppProvider appProvider = AppProvider();


  AuthenticationProvider() {
    _loadPreferences();
    _listenAuthChanges();
  }

  User? _user;
  String? _uid;
  String? _languageCode;
  bool _isLoading = true;


  User? get user => _user;
  String? get uid => _uid;
  String? get languageCode => _languageCode;
  bool get isLoading => _isLoading;

  set isLoading (bool value){
    _isLoading = value;
    notifyListeners();
  }

  void _listenAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      isLoading = false;
      print("Auth state changed: ${user?.uid}");
      notifyListeners(); // Notify UI about auth state change
    });
  }
Future<void> _loadPreferences() async {

  prefs = await SharedPreferences.getInstance();
    _uid = prefs.getString('auth_token');
    _languageCode = prefs.getString('languageCode');

    await Future.delayed(const Duration(seconds: 1)); // Simulated delay
print("... finished loading preferences");
print("... uid");
    isLoading = false;
 notifyListeners();
    if (_languageCode != null && _languageCode!.isNotEmpty) {
     
      appProvider.setPreferredLanguage(_languageCode!);
    }

  }

  

}
