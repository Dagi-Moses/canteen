import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../util/const.dart';

class UserProvider with ChangeNotifier {
  String _uid = '';
  String _name = '';
  String _email = '';
  String _address = '';
  String _phoneNumber = '';
  double _sellerTotalEarnings = 0;

  String? _profileImage = '';
  double get sellerTotalEarnings => _sellerTotalEarnings;

  String get id => _uid;
  String get name => _name;
  String get email => _email;

  String get phoneNumber => _phoneNumber;
  String? get profileImage => _profileImage;
  String get address => _address;

  void setUser({
    required String uid,
    required String name,
    required String email,
    required String address,
    required String gender,
    required String phoneNumber,
    String? profileImage,
  }) {
    _uid = id;
    _name = name;
    _email = email;
    _address = address;
    _phoneNumber = phoneNumber;

    _profileImage = profileImage;
    notifyListeners();
  }

  void setUserFromSnapshot(Map<String, dynamic> userData) {
    _uid = userData['uid'] ?? '';
    _name = userData['name'] ?? '';
    _email = userData['email'] ?? '';
    _address = userData['address'] ?? '';

    _phoneNumber = userData['phoneNumber'] ?? '';
    _profileImage = userData['profileImage'] ?? '';

    notifyListeners();
  }

  void updateUserName(String newName) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'name': newName,
      });
      _name = newName;
    } catch (e) {
      print('Error updating value in Firebase: $e');
    }

    notifyListeners();
  }

  void updateProfileImage(String newImage) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'profileImage': newImage});
      _profileImage = newImage;
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  void updateUserEmail(String newEmail) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'email': newEmail,
      });
      _email = newEmail;
    } catch (e) {
      print('Error updating value in Firebase: $e');
    }

    notifyListeners();
  }

  void updateUserAddress(String newAddress) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'address': newAddress,
      });
      _address = newAddress;
    } catch (e) {
      print('Error updating value in Firebase: $e');
    }

    notifyListeners();
  }

  void updatePhoneNumber(String phoneNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'phoneNumber': phoneNumber});
      _phoneNumber = phoneNumber;
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  retrieveSellerEarnings() async {
    await FirebaseFirestore.instance
        .collection("earnings")
        .doc('totalEarnings')
        .get()
        .then((snap) {
      _sellerTotalEarnings = double.parse(snap.data()!["earnings"].toString());
    });
      notifyListeners();
  }
}
