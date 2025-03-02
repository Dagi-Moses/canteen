
import 'package:canteen/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../util/const.dart';

class UserProvider with ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel ?_user; 
  double _sellerTotalEarnings = 0;

  UserModel? get user => _user;
  double get sellerTotalEarnings => _sellerTotalEarnings;



  // Update User and Sync to Firebase
  Future<void> updateUser({
  
  required UserModel updatedUser,
}) async {
  if (_user != null) {
    try {
      // Local Update
      _user = _user!.copyWith(
        firstName: updatedUser.firstName,
        lastName: updatedUser.lastName,
        phoneNumber: updatedUser.phoneNumber,
        country: updatedUser.country,
        state: updatedUser.state,
        city: updatedUser.city,
        address: updatedUser.address,
        zipCode: updatedUser.zipCode,
        completeAddress: updatedUser.completeAddress,
        email: updatedUser.email,
        profileImage: updatedUser.profileImage,
        
      );

      notifyListeners();

      // Firestore Update
       await _firestore.collection('users').doc(uid).update({
          ...updatedUser.toMap(),
          'updatedAt': FieldValue.serverTimestamp(), // Add update timestamp
        });
    } catch (e) {
      print('Failed to update user in Firestore: $e');
      rethrow; // Rethrow for handling in UI
    }
  }
}



void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
   void setUserFromSnapshot(Map<String, dynamic> userData) {
    _user = UserModel.fromMap(userData);
      WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }


   Future<void> updateUserName(String newName) async {
    if (_user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update({
        'name': newName,
      });
      _user = _user!.copyWith(firstName: newName);
      notifyListeners();
    } catch (e) {
      print('Error updating value in Firebase: $e');
    }
  }

  // Update profile image
  Future<void> updateProfileImage(String newImage) async {
    if (_user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update({
        'profileImage': newImage,
      });
      _user = _user!.copyWith(profileImage: newImage);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }


  void updateUserEmail(String newEmail) async {
    try {
      await firestore.collection('users').doc(uid).update({
        'email': newEmail,
      });
      _user = _user!.copyWith(email: newEmail);
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
  _user = _user!.copyWith(address: newAddress);
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
     _user = _user!.copyWith(phoneNumber: phoneNumber);
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
