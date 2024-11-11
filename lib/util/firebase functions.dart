import 'dart:async';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/geopoint.dart';
import '../../models/menus.dart';
import '../../models/order request.dart';
import '../../models/paystack_auth_response.dart';
import '../../models/review.dart';
import '../../models/transaction.dart';
import '../providers/provider.dart';

import '../screens/HomeLayout.dart';
import 'const.dart';

var uuid = Uuid();
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
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: 'Check your internet connection');
    } else {
      Fluttertoast.showToast(toastLength: Toast.LENGTH_LONG, msg: e.toString());
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

Future buyAllItemsInCart(
    {required PaymentMethod paymentMethod,
    required BuildContext context,
    required String note}) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .collection("cart")
      .get();

  for (int i = 0; i < snapshot.docs.length; i++) {
    Menus model = Menus.fromJson(json: snapshot.docs[i].data());

     await addProductToOrders(model: model, context: context, note: note, paymentMethod: paymentMethod);
     deleteProductFromCart(menuId: model.menuID);
    
  }
}

Future addProductToOrders(
    {required PaymentMethod paymentMethod,
    required Menus model,
    required BuildContext context,
    required String note}) async {
  await _firestore
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .collection("orders")
      .add(model.toJson());
  sendOrderRequest(
      model: model, context: context, note: note, paymentMethod: paymentMethod);
  Fluttertoast.showToast(msg: 'order placed');
}

Future<Map> getCurrenLocation() async {
  Map locationData = {};
  try {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark pMark = placeMarks[0];
    locationData['lat'] = position.latitude;
    locationData['long']= position.longitude;
    locationData['state'] = pMark.administrativeArea ?? "";
    String? city;
    if(pMark.subAdministrativeArea != null){
city = pMark.subAdministrativeArea;
    }
    else if (pMark.subLocality != null) {
      city = pMark.subLocality!;
    } else if (pMark.locality != null) {
      city = pMark.locality!;
    } else {
      // Handle the case where both subLocality and locality are null
      city = ""; // Or any default value you prefer
    }
    locationData['city'] = city;
   

    locationData['street'] = pMark.street ?? "";
  } catch (e) {
    Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: 'Check your internet & and allow location permission');
  }
   
    return locationData;
}
Map formatCoordinates(double latitude, double longitude) {
  Map data = {};
  String latDirection = latitude >= 0 ? 'N' : 'S';
  String lonDirection = longitude >= 0 ? 'E' : 'W';
  data['lat'] = '${latitude.abs().toStringAsFixed(10)}° $latDirection';
  data['long']= '${longitude.abs().toStringAsFixed(10)}° $lonDirection';
  return  data;
}
Future sendOrderRequest(
    {required PaymentMethod paymentMethod,
    required Menus model,
    required BuildContext context,
    required String note}) async {
 
  final userProvider = Provider.of<UserProvider>(context, listen: false);
   final ud = uuid.v1();
  print('starting');

  final locationData =  await getCurrenLocation();
    String state = locationData['state']!;
  String city = locationData['city']!;
  String street = locationData['street']!;
  
final cord = formatCoordinates(
      locationData['lat']!, locationData['long']!);

      GeoPoin geoPoin = GeoPoin(cord['lat'], cord['long']);
print(cord);
  Address address = Address(
      state: state,
      city: city,
      street: street,
      mobile: userProvider.phoneNumber,
      geoPoint: geoPoin);
      print(address);
  OrderRequestModel orderRequestModel = OrderRequestModel(
    id: userProvider.id,
    date: DateTime.now().millisecondsSinceEpoch,
    pickupOption: PickupOption.delivery,
    paymentMethod: paymentMethod.toString(),
    address: address,
    userId: userProvider.id,
    userName: userProvider.name,
    userImage: userProvider.profileImage ?? '',
    userPhone: userProvider.phoneNumber,
    userNote: note,
    employeeCancelNote: "",
    deliveryStatus: DeliveryStatus.pending,
    deliveryId: ud,
    deliveryGeoPoint: geoPoin,
    menuTitle: model.menuTitle,
    menuID: model.menuID,
    menuPrice: model.menuPrice,
  );
  await _firestore.collection("orders").doc(ud).set(orderRequestModel.toJson());
  final menuProvider = Provider.of<MenuProvider>(context, listen: false);
  // await _firestore
  //     .collection("earnings")
  //     .doc('totalEarnings')
  //     .get()
  //     .then((snap) {
  //   double earnings = double.parse(snap.data()!["earnings"]);
  //   double TotalEarnings = earnings + menuProvider.totalCartPrice;
  //   _firestore
  //       .collection("earnings")
  //       .doc('totalEarnings')
  //       .set({"earnings": TotalEarnings});
  // });
  final earningsDocRef = _firestore.collection("earnings").doc('totalEarnings');
  final earningsSnapshot = await earningsDocRef.get();
  if (earningsSnapshot.exists) {
    double earnings = double.parse(earningsSnapshot.data()!["earnings"] ?? '0');
    double totalEarnings = earnings + menuProvider.totalCartPrice;
    await earningsDocRef.update({"earnings": totalEarnings});
  } else {

    await earningsDocRef.set({"earnings": menuProvider.totalCartPrice});
  }

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