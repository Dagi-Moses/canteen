import 'dart:async';
import 'dart:convert';
import 'package:canteen/models/user.dart';
import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/util/routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/geopoint.dart';
import '../../models/menus.dart';
import '../../models/order request.dart';
import '../../models/paystack_auth_response.dart';
import '../../models/review.dart';
import '../../models/transaction.dart';
import 'userProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../util/const.dart';

class FirebaseFunctions extends ChangeNotifier {
  var uuid = Uuid();
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
     // Navigator.of(context).pushReplacementNamed(Routes.homeLayout);
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

  Future likePost({
    required String postId,
    required List likes,
    required int likesCount,
  }) async {
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

  Future addProductToCart({
    required Menus menu,
    required AppLocalizations app,
    required int quantity, // Pass the quantity
  }) async {
    final cartRef = _firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("cart")
        .doc(menu.menuID);

    final cartItem = await cartRef.get();

    if (cartItem.exists) {
     
      int currentQuantity = cartItem.data()?['quantity'] ?? 1;
      await cartRef.update({"quantity": currentQuantity + quantity});
    } else {
      // If item is not in the cart, add it with the specified quantity
      await cartRef.set(menu.toJson()..['quantity'] = quantity);
    }

    Fluttertoast.showToast(msg: app.addedToCart);
  }


  // Future addProductToCart({
  //   required Menus menu,
  //   required AppLocalizations app,
  //    required int quantity,
  // }) async {
  //   await _firestore
  //       .collection("users")
  //       .doc(firebaseAuth.currentUser!.uid)
  //       .collection("cart")
  //       .doc(menu.menuID)
  //       .set(menu.toJson());
  //   Fluttertoast.showToast(msg: app.addedToCart);
  // }

  Future deleteProductFromCart({required String menuId}) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("cart")
        .doc(menuId)
        .delete();
    MenuProvider().minusCartNo();
  }

  Future buyAllItemsInCart({
    required PaymentMethod paymentMethod,
    required BuildContext context,
    required String note,
    required AppLocalizations app,
  }) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("cart")
        .get();

    for (int i = 0; i < snapshot.docs.length; i++) {
      Menus model = Menus.fromJson(json: snapshot.docs[i].data());

      await addProductToOrders(
          model: model,
          context: context,
          note: note,
          paymentMethod: paymentMethod,
          app: app);
      deleteProductFromCart(menuId: model.menuID);
    }
  }

  Future addProductToOrders(
      {required PaymentMethod paymentMethod,
      required Menus model,
      required BuildContext context,
      required String note,
      required AppLocalizations app}) async {
    await _firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("orders")
        .add(model.toJson());
    sendOrderRequest(
        model: model,
        context: context,
        note: note,
        paymentMethod: paymentMethod);
    Fluttertoast.showToast(msg: app.orderPlaced);
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
      locationData['long'] = position.longitude;
      locationData['state'] = pMark.administrativeArea ?? "";
      String? city;
      if (pMark.subAdministrativeArea != null) {
        city = pMark.subAdministrativeArea;
      } else if (pMark.subLocality != null) {
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
    data['long'] = '${longitude.abs().toStringAsFixed(10)}° $lonDirection';
    return data;
  }

  Future sendOrderRequest(
      {required PaymentMethod paymentMethod,
      required Menus model,
      required BuildContext context,
      required String note}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ud = uuid.v1();
    print('starting');

    final locationData = await getCurrenLocation();
    String state = locationData['state']!;
    String city = locationData['city']!;
    String street = locationData['street']!;

    final cord = formatCoordinates(locationData['lat']!, locationData['long']!);

    GeoPoin geoPoin = GeoPoin(cord['lat'], cord['long']);
    print(cord);
    Address address = Address(
        state: state,
        city: city,
        street: street,
        mobile: userProvider.user!.phoneNumber!,
        geoPoint: geoPoin);
    print(address);
    OrderRequestModel orderRequestModel = OrderRequestModel(
      id: userProvider.user!.uid!,
      date: DateTime.now().millisecondsSinceEpoch,
      pickupOption: PickupOption.delivery,
      paymentMethod: paymentMethod.toString(),
      address: address,
      userId: userProvider.user!.uid!,
      userName: userProvider.user!.firstName!,
      userImage: userProvider.user!.profileImage!,
      userPhone: userProvider.user!.phoneNumber!,
      userNote: note,
      employeeCancelNote: "",
      deliveryStatus: DeliveryStatus.pending,
      deliveryId: ud,
      deliveryGeoPoint: geoPoin,
      menuTitle: model.menuTitle,
      menuID: model.menuID,
      menuPrice: model.menuPrice,
    );
    await _firestore
        .collection("orders")
        .doc(ud)
        .set(orderRequestModel.toJson());
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
    final earningsDocRef =
        _firestore.collection("earnings").doc('totalEarnings');
    final earningsSnapshot = await earningsDocRef.get();
    if (earningsSnapshot.exists) {
      double earnings =
          double.parse(earningsSnapshot.data()!["earnings"] ?? '0');
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
          email: userProvider.user!.email!);
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
    final String apiUrl =
        'https://api.paystack.co/transaction/verify/$reference';
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
}
