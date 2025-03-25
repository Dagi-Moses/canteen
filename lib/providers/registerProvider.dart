import 'dart:async';
import 'dart:convert';
import 'package:canteen/providers/firebase%20functions.dart';
import 'package:canteen/util/arguments.dart';
import 'package:canteen/widgets/snackBar.dart';
import 'package:http/http.dart' as http;
import 'package:canteen/models/user.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/util/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RegistrationProvider with ChangeNotifier {
  FirebaseFunctions firebaseFunctions = FirebaseFunctions();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(bool value) {
    _hasError = value;
    notifyListeners();
  }

  String _currentText = "";
  String get currentText => _currentText;
  set currentText(String value) {
    _currentText = value;
    notifyListeners();
  }

  Future<void> storeAuthToken(String authToken) async {
    prefs.setString('auth_token', authToken);
  }

  Future<void> sendOtp(
      {
      required UserModel user,
      required String password,
      TextEditingController? resendController, // Optional parameter
      required bool isResend,
      required BuildContext context,
      required AppLocalizations app}) async {
    isLoading = true;
    errorMessage = null;

    try {
      if (isResend) {
        resendController!.clear();
      }
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(user.email!);
      if (signInMethods.isEmpty) {
        final response = await http.post(
          Uri.parse('${Constants.serverUrl}/send-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': user.email?.trim(),
          }),
        )
            .timeout(
          Duration(seconds: 16), // Timeout duration
          onTimeout: () {
            throw TimeoutException("OTP request timed out");
          },
        );
        print("message + ${response.body}");
        if (response.statusCode == 200) {
          errorMessage = null;
          if (isResend) {
            snackBar(app.otpResent, context);
          } else {
            Navigator.pushNamed(
              context,
              Routes.regCodeVerification,
              arguments: RegistrationCodeVerificationArgs(
                user: user,
                password: password,
              ),
            );
          }
        } else {
          errorMessage = app.failedToSendOtp;
        }
      } else {
        errorMessage = app.emailAlreadyInUse;
      }
    } catch (error) {
      errorMessage = app.anError;
      print(error);
    } finally {
      isLoading = false;

   
    }
  }

  Future<void> verifyOtp(
      {required UserModel user,
      required String password,
      required BuildContext context,
      StreamController<ErrorAnimationType>? errorController,
      required AppLocalizations app}) async {
    isLoading = true;
    errorMessage = null;

    try {
      final response = await http.post(
        Uri.parse('${Constants.serverUrl}/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'email': user.email?.trim(), 'otp': _currentText, "type": "register"}),
      )
          .timeout(
        Duration(seconds: 40), // Timeout duration
        onTimeout: () {
          throw TimeoutException("OTP request timed out");
        },
      );
      print("response: ${response.body.toString()}");
      if (response.statusCode == 200) {
        currentText = '';
        await signUpAndStoreUserData(
          app: app,
          context: context,
          user: user,
          password: password,
        );
      } else {
        errorMessage = app.invalidOtp;
        errorController
            ?.add(ErrorAnimationType.shake); // Trigger shake animation
      }
    } catch (error) {
      errorMessage = app.anError;
      errorController?.add(ErrorAnimationType.shake); // Trigger shake animation
      print("Error: ${error}");
    } finally {
      isLoading = false;
    }
  }

  signUpAndStoreUserData({
    required UserModel user,
    required String password,
    required BuildContext context,
    required AppLocalizations app,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email!.trim(),
            password: password.trim(),
          )
          .timeout(Duration(seconds: 90));

      final UserModel userData = await user.copyWith(uid: userCredential.user?.uid);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData.uid)
          .set(userData.toMap());
      Navigator.of(context).pushReplacementNamed(Routes.homeLayout);
      storeAuthToken(userData.uid!);
    } on FirebaseAuthException catch (e) {
      String error;
      switch (e.code) {
        case 'email-already-in-use':
          error = app.emailAlreadyInUse;
          break;
        case 'invalid-email':
          error = app.invalidEmail;
          break;
        case 'weak-password':
          error = app.weakPassword;
          break;
        case 'wrong-password':
          error = app.wrongPassword;
          break;
        case 'user-not-found':
          error = app.userNotFound;
          break;
        case 'network-request-failed':
          error = app.networkRequestFailed;
          break;
        default:
          error = app.unexpectedError;
      }
      errorMessage = error;
    } on TimeoutException {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG, msg: app.checkUrInternet);
    } catch (e) {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "An error occurred: ${e.toString()}");
    }
  }
}
