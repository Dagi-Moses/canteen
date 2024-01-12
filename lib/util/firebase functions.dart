import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/menus.dart';
import '../../models/order request.dart';
import '../../models/paystack_auth_response.dart';
import '../../models/review.dart';
import '../../models/transaction.dart';
import '../providers/provider.dart';
import '../screens/HomeLayout.dart';
import 'const.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
Future<void> storeAuthToken(String authToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('auth_token', authToken);
}

signUpAndStoreUserData(
  String name,
  String email,
  String password,
  String phoneNumber,
  BuildContext context,
  String text,
  Function(bool) setIsLoading,
) async {
  try {
    bool hasTimedOut = false;
    setIsLoading(true);
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
        .timeout(Duration(seconds: 90));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      "address": text,
      'uid': userCredential.user!.uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      "profileImage": '',
      'dateJoined': DateTime.now(),
    });

    setIsLoading(false);
    storeAuthToken(userCredential.user!.uid);
    if (!hasTimedOut) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return HomeLayout(uid: FirebaseAuth.instance.currentUser!.uid);
      }));
    }
  } catch (e) {
    setIsLoading(false);
    if (e is TimeoutException) {
      Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: 'Check your internet connection');
    } else {
      Fluttertoast.showToast( toastLength: Toast.LENGTH_LONG, msg: e.toString());
    }
  }
}

Future<void> signInUser({
  required String email,
  required String password,
  required BuildContext context,
  required Function(bool) setIsLoading,
}) async {
  try {
    bool hasTimedOut = false;
    setIsLoading(true);

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(Duration(seconds: 90));

    setIsLoading(false);
    storeAuthToken(userCredential.user!.uid);
    if (!hasTimedOut) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) {
          return HomeLayout(uid: userCredential.user!.uid);
        }),
      );
    }
  } catch (e) {
    setIsLoading(false);
    if (e is TimeoutException) {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: 'Check your internet connection');
    } else {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: e.toString(),
      );
    }
  }
}

Future likePost(
    {required String postId,
    required List likes,
    required int likesCount}) async {
  String uid = _auth.currentUser!.uid;
  try {
    if (likes.contains(uid)) {
      int newLikes = likesCount - 1;

      _firestore.collection('menus').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid]),
        'likesCount': newLikes
      });
    } else {
      int newLikes = likesCount + 1;
      _firestore.collection('menus').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid]),
        'likesCount': newLikes,
      });
    }
  } catch (err) {
    print(err.toString());
  }
}

Future addProductToCart({required Menus menu}) async {
  await _firestore
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .collection("cart")
      .doc(menu.menuID)
      .set(menu.toJson());
  Fluttertoast.showToast(msg: "added to cart");
}

Future deleteProductFromCart({required String menuId}) async {
  await _firestore
      .collection("users")
      .doc(uid)
      .collection("cart")
      .doc(menuId)
      .delete();
  MenuProvider().minusCartNo();
}

Future buyAllItemsInCart({required BuildContext context}) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .collection("cart")
      .get();

  for (int i = 0; i < snapshot.docs.length; i++) {
    Menus model = Menus.fromJson(json: snapshot.docs[i].data());

    addProductToOrders(model: model, context: context);
    await deleteProductFromCart(menuId: model.menuID);
  }
}

Future addProductToOrders(
    {required Menus model, required BuildContext context}) async {
  await _firestore
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .collection("orders")
      .add(model.toJson());
  sendOrderRequest(model: model, context: context);
  Fluttertoast.showToast(msg: 'order placed');
}

Future sendOrderRequest(
    {required Menus model, required BuildContext context}) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  OrderRequestModel orderRequestModel = OrderRequestModel(
    status: 'ordered',
    menuTitle: model.menuTitle,
    buyersAddress: userProvider.address,
    menuID: model.menuID,
    menuPrice: model.menuPrice,
    orderDate: DateTime.now(),
    userId: userProvider.id,
    username: userProvider.name,
    thumbnailUrl: model.thumbnailUrl,
    itemCount: 1,
    delivered: false,
  );
  await _firestore.collection("orders").add(orderRequestModel.getJson());
  final menuProvider = Provider.of<MenuProvider>(context, listen: false);
  await _firestore
      .collection("earnings")
      .doc('totalEarnings')
      .get()
      .then((snap) {
    double earnings = double.parse(snap.data()!["earnings"]);
    double TotalEarnings = earnings + menuProvider.totalCartPrice;
    _firestore
        .collection("earnings")
        .doc('totalEarnings')
        .set({"earnings": TotalEarnings});
  });
}

Future<String> getUserImage() async {
  String uid = _auth.currentUser!.uid;
  DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
  String image = (snap.data()! as dynamic)['profileImage'];
  return image;
}

Future uploadReview(
    {required String menuId,
    required Review model,
    required Menus menu}) async {
  await _firestore
      .collection("menus")
      .doc(menuId)
      .collection("reviews")
      //.doc(_auth.currentUser!.uid).set();
      .add(model.getJson());
  await changeAverageRating(menuId: menuId, reviewModel: model, menu: menu);
}

Future changeAverageRating(
    {required String menuId,
    required Review reviewModel,
    required Menus menu}) async {
  String uid = _auth.currentUser!.uid;
  DocumentSnapshot snapshot =
      await _firestore.collection("menus").doc(menuId).get();
  Menus model = Menus.fromJson(json: (snapshot.data() as dynamic));
  double currentRating = model.rating;
  double userRating = reviewModel.rating;
  int currentRaters = model.raters.length;
  double newRating =
      ((currentRating * currentRaters) + userRating) / (currentRaters + 1);

  await _firestore
      .collection("menus")
      .doc(menuId)
      .update({"rating": newRating});
  if (!menu.raters.contains(uid)) {
    _firestore.collection('menus').doc(menuId).update({
      'raters': FieldValue.arrayUnion([uid])
    });
  }
}

Future<String> initializeTransaction({
  required BuildContext context,
}) async {
  final menuProvider = Provider.of<MenuProvider>(context, listen: false);
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  double amount = await menuProvider.totalCartPrice * 100;
  try {
    final transaction = await Transactions(
        amount: amount.toString(),
        reference: DateTime.now().microsecondsSinceEpoch.toString(),
        currency: 'NGN',
        email: userProvider.email);
    final authResponse = await createTransaction(transaction, context);
    //return authResponse.authUrl;
    return '${authResponse.authUrl}|${authResponse.reference}';
  } catch (e) {
    print('Error in initializeTransaction: $e');
    return 'payment unsuccessful \n check ur connection';
  }
}

Future<PayStackAuthResponse> createTransaction(
    Transactions transaction, BuildContext context) async {
  const String url = "https://api.paystack.co/transaction/initialize";
  final data = transaction.toJson();

  try {
    final response = await http.post(Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${Constants.apiKey}",
          'Content-Type': "application/json"
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      return PayStackAuthResponse.fromJson(responseData['data']);
    } else {
      print(response.body);
      throw response.body;
    }
  } on Exception {
    throw 'payment unsuccessful \n check ur connection ';
  }
}

Future<bool> verifyPaystackTransaction(String reference) async {
  final String apiUrl = 'https://api.paystack.co/transaction/verify/$reference';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer ${Constants.apiKey}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == true &&
          responseData['data']['status'] == 'success') {
        return true;
      } else {
        return false;
      }
    } else {
      print('Error verifying transaction: ${response.statusCode}');
      print(response.body);
      return false;
    }
  } catch (e) {
    print('Exception verifying transaction: $e');
    return false;
  }
}

  
 

// Future uploadReview({required String menuId, required Review model}) async {
//   // Check if the user has already submitted a review
//   QuerySnapshot query = await _firestore
//       .collection("menus")
//       .doc(menuId)
//       .collection("reviews")
//       .where('raterId', isEqualTo: model.raterId)
//       .get();

//   if (query.docs.isNotEmpty) {
//     // User has already submitted a review, update the existing one
//     String existingReviewId = query.docs.first.id;
//     await _firestore
//         .collection("menus")
//         .doc(menuId)
//         .collection("reviews")
//         .doc(existingReviewId)
//         .update(model.getJson());
//   } else {
//     // User is submitting a new review
//     await _firestore
//         .collection("menus")
//         .doc(menuId)
//         .collection("reviews")
//         .add(model.getJson());
//   }

//   await changeAverageRating(menuId: menuId);
// }

// Future changeAverageRating({required String menuId}) async {
//   QuerySnapshot reviewsSnapshot = await _firestore
//       .collection("menus")
//       .doc(menuId)
//       .collection("reviews")
//       .get();

//   // Calculate the new average rating
//   double totalRating = 0;
//   int totalRaters = reviewsSnapshot.docs.length;

//   for (QueryDocumentSnapshot reviewDoc in reviewsSnapshot.docs) {
//     Review review = Review.fromJson(json: reviewDoc.data() as dynamic);
//     totalRating += review.rating;
//   }

//   double newRating = totalRating / totalRaters;

//   // Update the menu with the new average rating
//   await _firestore.collection("menus").doc(menuId).update({"rating": newRating});
// }