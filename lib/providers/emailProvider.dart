import 'dart:async';
import 'package:canteen/providers/firebase%20functions.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailProvider with ChangeNotifier {
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

  Future<void> sendOtp(
      {TextEditingController? resendController, // Optional parameter
      required bool isResend,
      required String email,
      required BuildContext context,
      required AppLocalizations app}) async {
    isLoading = true;
    errorMessage = null;

    try {
      if (isResend) {
        resendController!.clear();
      }
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        final response = await http.post(
          Uri.parse('${Constants.serverUrl}/send-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
          }),
        );
        print("message + ${response.body}");
        if (response.statusCode == 200) {
          errorMessage = null;
          isLoading = false;

          if (!isResend) {
            Navigator.of(context).pushNamed(
              Routes.pinCodeVerification,
              arguments: email,
            );
          } else {
            snackBar(app.otpResent, context);
          }
        } else {
          errorMessage = app.failedToSendOtp;
        }
      } else {
        errorMessage = app.noAccountFound;
      }
    } catch (error) {
      errorMessage = app.anError;
      print(error);
      snackBar(error.toString(), context);
    } finally {
      isLoading = false;
    }
  }

  bool _isLinkSent = false;

  bool get isLinkSent => _isLinkSent;

  set isLinkSent(bool value) {
    _isLinkSent = value;
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail(
      {required String email, required AppLocalizations app}) async {
    isLoading = true;

    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        isLinkSent = true;
      } else {
        errorMessage = app.noAccountFound;
      }
    } catch (e) {
      errorMessage = app.anError;
      print("Error: $e");
    } finally {
      isLoading = false;
    }
  }

  Future<void> verifyOtp(
      String email,
      BuildContext context,
      StreamController<ErrorAnimationType>? errorController,
      AppLocalizations app) async {
    isLoading = true;

    try {
      final response = await http.post(
        Uri.parse('${Constants.serverUrl}/verify-otp'), // Backend API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': _currentText}),
      );
      print("response: ${response.body.toString()}");
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final customToken = responseBody['customToken']
            as String?; // The custom token sent from the server
        if (customToken != null) {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCustomToken(customToken);
          Navigator.of(context).pushNamed(Routes.homeLayout);
          firebaseFunctions.storeAuthToken(userCredential.user!.uid);
          errorMessage = null;
        } else {
          errorMessage = app.failedCustomToken;
          errorController!
              .add(ErrorAnimationType.shake); // Trigger shake animation
        }
      } else {
        errorMessage = app.invalidOtp;
        errorController!
            .add(ErrorAnimationType.shake); // Trigger shake animation
      }
    } catch (error) {
      errorMessage = app.anError;
      errorController!.add(ErrorAnimationType.shake); // Trigger shake animation
      print("Error: ${error}");
    } finally {
      isLoading = false;
    }
  }
}
