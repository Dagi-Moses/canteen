import 'package:canteen/admin/screens/home_screen.dart';
import 'package:canteen/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> signUpAndStoreUserData(
    String name,
  
    String email,
    String password,
   
    BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'uid': userCredential.user!.uid,
      'name': name,
      
      'email': email,
      
      'dateJoined': DateTime.now(),
      
    });
    Navigator.push(context,
       MaterialPageRoute(builder: (_){
        return MainScreen();
       }));
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> signInUser(
    {required String email,
    required String password,
    required BuildContext context}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if(userCredential.user!.uid == 'S6hMPwvFmWc08JfLMhwEScXd5p23'){
  Navigator.push(context,
       MaterialPageRoute(builder: (_){
        return HomeScreen();
       }));
    }else{
        Navigator.push(context,
       MaterialPageRoute(builder: (_){
        return MainScreen();
       }));
    }

  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Credential'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}