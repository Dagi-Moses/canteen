import 'package:canteen/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../util/const.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  UserModel? _user;
  double _sellerTotalEarnings = 0;

  UserModel? get user => _user;
  double get sellerTotalEarnings => _sellerTotalEarnings;

  void setUserFromSnapshot(Map<String, dynamic> userData) {
    _user = UserModel.fromMap(userData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> updateUser({
    required UserModel updatedUser,
  }) async {
    if (_user != null) {
      try {
       isLoading = true;
        _user = _user!.copyWith(

          dateJoined: updatedUser.dateJoined != null
              ? updatedUser.dateJoined
              : _user!.dateJoined,
          email: updatedUser.email?.isNotEmpty == true
              ? updatedUser.email
              : _user!.email,
          firstName: updatedUser.firstName?.isNotEmpty == true
              ? updatedUser.firstName
              : _user?.firstName,
          lastName: updatedUser.lastName?.isNotEmpty == true
              ? updatedUser.lastName
              : _user?.lastName,
          phoneNumber: updatedUser.phoneNumber?.isNotEmpty == true
              ? updatedUser.phoneNumber
              : _user?.phoneNumber,
          country: updatedUser.country?.isNotEmpty == true
              ? updatedUser.country
              : _user?.country,
          state: updatedUser.state?.isNotEmpty == true
              ? updatedUser.state
              : _user?.state,
          city: updatedUser.city?.isNotEmpty == true
              ? updatedUser.city
              : _user?.city,
          address: updatedUser.address?.isNotEmpty == true
              ? updatedUser.address
              : _user?.address,
          zipCode: updatedUser.zipCode?.isNotEmpty == true
              ? updatedUser.zipCode
              : _user?.zipCode,
          completeAddress: updatedUser.completeAddress?.isNotEmpty == true
              ? updatedUser.completeAddress
              : _user?.completeAddress,
          profileImage: updatedUser.profileImage?.isNotEmpty == true
              ? updatedUser.profileImage
              : _user?.profileImage,
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
      }finally{
          isLoading = false;
      }
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
