import 'dart:async';

import 'package:canteen/models/user.dart';

import 'package:canteen/util/routes.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/menus.dart';

import '../../models/review.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../util/const.dart';

class FirebaseFunctions extends ChangeNotifier {


  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isRegisterLoading = false;
  bool get isRegisterLoading => _isRegisterLoading;

  set isRegisterLoading(bool value) {
    _isRegisterLoading = value;
    notifyListeners();
  }

  String? _loginErrorMsg ;
  String? get loginErrorMsg => _loginErrorMsg;

  set loginErrorMsg(String ?value) {
    _loginErrorMsg = value;
    notifyListeners();
  }

  String? _registerErrorMsg ;
  String ? get registerErrorMsg => _registerErrorMsg;

  set registerErrorMsg(String? value) {
    _registerErrorMsg = value;
    notifyListeners();
  }

  Future<void> storeAuthToken(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', authToken);
  }

  signUpAndStoreUserData({
    required String email,
    required String password,
    required String firstName,
    required String phoneNumber,
    String? completeAddress,
    String? address,
    String? country,
    String? state,
    String? city,
    String? zipCode,
    required BuildContext context,
    required AppLocalizations app,
  }) async {
      isRegisterLoading = true;
    try {

     

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(Duration(seconds: 90));

      final user = UserModel(
        lastName: '',
        uid: userCredential.user!.uid,
        firstName: firstName,
        address: address,
        completeAddress: completeAddress,
        email: email,
        phoneNumber: phoneNumber,
        dateJoined: DateTime.now(),
        profileImage: '',
        country: country,
        city: city,
        state: state,
        zipCode: zipCode,
      );

     print("Attempting to store user data...");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(user.toMap());
      print("User data stored successfully.");

      Navigator.of(context).pushReplacementNamed(Routes.homeLayout);
      storeAuthToken(user.uid!);
    
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = app.emailAlreadyInUse;
          break;
        case 'invalid-email':
          errorMessage = app.invalidEmail;
          break;
        case 'weak-password':
          errorMessage = app.weakPassword;
          break;
        case 'wrong-password':
          errorMessage = app.wrongPassword;
          break;
        case 'user-not-found':
          errorMessage = app.userNotFound;
          break;
        case 'network-request-failed':
          errorMessage = app.networkRequestFailed;
          break;
        default:
          errorMessage = app.unexpectedError;
      }
      registerErrorMsg = errorMessage;
    } on TimeoutException {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG, msg: app.checkUrInternet);
    } catch (e) {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "An error occurred: ${e.toString()}");
    } finally {
      isRegisterLoading = false;
         print("ended...");
  
    }
  }

  Future<void> signInUser({
    required String email,
    required String password,
    required BuildContext context,
    required AppLocalizations app,
  }) async {
    try {
      loginErrorMsg = null;
      isLoading = true;

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password.trim())
          .timeout(Duration(seconds: 90));
      Navigator.of(context).pushReplacementNamed(Routes.homeLayout);
      storeAuthToken(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = app.emailAlreadyInUse;
          break;
        case 'invalid-email':
          errorMessage = app.invalidEmail;
          break;
        case 'weak-password':
          errorMessage = app.weakPassword;
          break;
        case 'wrong-password':
          errorMessage = app.wrongPassword;
          break;
        case 'user-not-found':
          errorMessage = app.userNotFound;
          break;
        case 'network-request-failed':
          errorMessage = app.networkRequestFailed;
          break;
        default:
          errorMessage = app.unexpectedError;
      }
      loginErrorMsg = errorMessage;
    } on TimeoutException {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG, msg: app.checkUrInternet);
    } catch (e) {
      print("login error: ${e.toString()}");
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: e.toString(),
      );
    } finally {
      isLoading = false;
    }
  }


  Future<String> getUserImage() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    String image = (snap.data()! as dynamic)['profileImage'];
    return image;
  }

  Future uploadReview(
      {
      required Review model,
      required Menus menu}) async {
    await _firestore
        .collection("menus")
        .doc(menu.menuID)
        .collection("reviews")
        //.doc(_auth.currentUser!.uid).set();
        .add(model.getJson());
    await changeAverageRating( reviewModel: model, menu: menu);
  }

  Future changeAverageRating(
      {
      required Review reviewModel,
      required Menus menu}) async {

    DocumentSnapshot snapshot =
        await _firestore.collection("menus").doc(menu.menuID).get();
    Menus model = Menus.fromJson(json: (snapshot.data() as dynamic));
    double currentRating = model.rating;
    double userRating = reviewModel.rating;
    int currentRaters = model.raters.length;
    double newRating =
        ((currentRating * currentRaters) + userRating) / (currentRaters + 1);

    await _firestore
        .collection("menus")
        .doc(menu.menuID)
        .update({"rating": newRating});
    if (!menu.raters.contains(uid)) {
      _firestore.collection('menus').doc(menu.menuID).update({
        'raters': FieldValue.arrayUnion([uid])
      });
    }
  }


}
