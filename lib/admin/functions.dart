import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/userProvider.dart';
import '../util/const.dart';

takeImage({required BuildContext context}) {
  return showDialog(
      context: context,
      builder: (c) {
        return SimpleDialog(
          title: const Text(
            "SELECT",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              child: const Text(
                "Capture with Camera",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => captureImageWithCamera(context: context),
            ),
            SimpleDialogOption(
              child: const Text(
                "Select from Gallery",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => pickImageFromGallery(context: context),
            ),
            SimpleDialogOption(
              child: const Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      });
}

//capture with camera
captureImageWithCamera({required BuildContext context}) async {
  Navigator.pop(context);

  final ImagePicker _picker = ImagePicker();
  XFile? imageXFile = await _picker.pickImage(
    source: ImageSource.camera,
    maxHeight: 720.0,
    maxWidth: 1280.0,
  );
  uploadImage(context, imageXFile);
}

//select image from gallery
pickImageFromGallery({
  required BuildContext context,
}) async {
  Navigator.pop(context);
  final ImagePicker _picker = await ImagePicker();
  XFile? imageXFile = await _picker.pickImage(
    source: ImageSource.gallery,
    maxHeight: 720.0,
    maxWidth: 1280.0,
  );
  uploadImage(context, imageXFile);
}

uploadImage(
  BuildContext context,
  imageXFile,
) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  try {
    final storageRef =
        FirebaseStorage.instance.ref().child('profileImage').child(uid);

    UploadTask uploadTask = storageRef.putFile(File(imageXFile.path));
    TaskSnapshot snapshot = await uploadTask;

    final imageUrl = await storageRef.getDownloadURL();

    userProvider.updateProfileImage(imageUrl);
  } catch (e) {
    print(e);
  }
}

String api = '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';
