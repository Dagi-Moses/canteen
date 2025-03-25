
import 'package:canteen/models/user.dart';
import 'package:canteen/providers/userProvider.dart';
import 'package:canteen/widgets/snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUser({
    required UserProvider userProvider,
    required UserModel updatedUser,
    required BuildContext context,
  }) async {
    if (userProvider.user == null) {
      _showError(context, "User data not found.");
      return;
    }

    try {
      userProvider.isLoading = true;

      String uid = userProvider.user!.uid!;
      Map<String, dynamic> updates = {};

      // Only update changed fields
      if (updatedUser.firstName != userProvider.user!.firstName) {
        updates['firstName'] = updatedUser.firstName;
      }
      if (updatedUser.lastName != userProvider.user!.lastName) {
        updates['lastName'] = updatedUser.lastName;
      }
      if (updatedUser.phoneNumber != userProvider.user!.phoneNumber) {
        updates['phoneNumber'] = updatedUser.phoneNumber;
      }
      if (updatedUser.country != userProvider.user!.country) {
        updates['country'] = updatedUser.country;
      }
      if (updatedUser.state != userProvider.user!.state) {
        updates['state'] = updatedUser.state;
      }
      if (updatedUser.city != userProvider.user!.city) {
        updates['city'] = updatedUser.city;
      }
      if (updatedUser.address != userProvider.user!.address) {
        updates['address'] = updatedUser.address;
      }
      if (updatedUser.zipCode != userProvider.user!.zipCode) {
        updates['zipCode'] = updatedUser.zipCode;
      }
      // if (updatedUser.profileImage != userProvider.user!.profileImage) {
      //   updates['profileImage'] = updatedUser.profileImage;
      // }

      if (updates.isNotEmpty) {
        updates['updatedAt'] = FieldValue.serverTimestamp(); // Track updates
        await _firestore.collection('users').doc(uid).update(updates);
        // userProvider
        //     .setUserFromSnapshot({...userProvider.user!.toMap(), ...updates});
      }

      snackBar("Profile updated successfully!",  context);
    } catch (e) {
      _showError(context, "Failed to update profile. Try again.");
    } finally {
      userProvider.isLoading = false;
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red),
    );
  }
}
