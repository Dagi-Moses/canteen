import 'dart:convert';

import 'package:canteen/models/geopoint.dart';
import 'package:canteen/models/menus.dart';
import 'package:canteen/models/order%20request.dart';
import 'package:canteen/models/paystack_auth_response.dart';
import 'package:canteen/models/transaction.dart';
import 'package:canteen/providers/userProvider.dart';

import 'package:canteen/util/const.dart';
import 'package:canteen/util/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
final UserProvider userProvider; // Store userProvider reference

  CartProvider({required this.userProvider}) {
    _initializeCartStream();
  }
  var uuid = Uuid();
  final _firestore = FirebaseFirestore.instance;
  List<Menus> _cartMenus = [];
  List<Menus> get cartMenus => _cartMenus;
  int get cartNo => _cartMenus.length;

  double get totalCartPrice {
    double total = 0;

    for (var menu in _cartMenus) {
      total += menu.menuPrice * menu.quantity;
    }
    return total + deliveryFee;
  }

  double get deliveryFee {
    String? state = address?.state?.toLowerCase().trim();

    if (state == null || !state.contains("lagos")) {
      return double.infinity;
    }
    if (address?.geoPoint == null) {
      return 0;
    }
    double distance = Geolocator.distanceBetween(
            Constants.STORE_LAT,
            Constants.STORE_LONG,
            address!.geoPoint!.latitude,
            address!.geoPoint!.longitude) /
        1000;

    // Calculate delivery fee based on distance
    return calculateDeliveryFee(distance);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Address? _address;
  Address? get address => _address;

  set address(Address? value) {
    _address = value;
    notifyListeners();
  }

  String? _fullAddress;
  String? get fullAddress => _fullAddress;

  set fullAddress(String? value) {
    _fullAddress = value;
    notifyListeners();
  }

  String? _selectedObject;
  String? get selectedObject => _selectedObject;

  set selectedObject(String? value) {
    if (_selectedObject != value) {
      _selectedObject = value;
      notifyListeners();
    }
  }

  void checkOut({
    required AppLocalizations app,
    required BuildContext context,
    required String deliveryNote,
  }) async {
    String? state = address?.state?.toLowerCase().trim();

    if (state == null || !state.contains("lagos")) {
      Fluttertoast.showToast(
        msg: app.deliveryNotAvailable, // Localized error message
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (selectedObject == app.cash) {
      await buyAllItemsInCart(
          context: context,
          note: deliveryNote,
          paymentMethod: PaymentMethod.cash,
          app: app);

      Navigator.pop(context);
    } else {
      Navigator.pushNamed(context, Routes.paymentPage, arguments: deliveryNote);
    }
  }
  

  void _initializeCartStream() {
    _firestore
        .collection("users")
        .doc(uid)
        .collection("cart")
        .orderBy('publishDate', descending: true)
        .snapshots()
        .listen((snapshot) {
      updateCartMenusFromSnapshot(snapshot);
    });
  }

  void updateCartMenusFromSnapshot(QuerySnapshot snapshot) {
    final updatedMenus = snapshot.docs.map((doc) {
      return Menus.fromJson(json: doc.data() as Map<String, dynamic>);
    }).toList();

    _cartMenus = updatedMenus;
    notifyListeners();
  }

  Map<String, int> _cartItems = {}; // Stores menuID and quantity

  int getQuantity(String menuID) => _cartItems[menuID] ?? 1;

  void addQuantity(String menuID) {
    _cartItems[menuID] = (_cartItems[menuID] ?? 1) + 1;
    notifyListeners();
  }

  void removeQuantity(String menuID) {
    if (_cartItems.containsKey(menuID) && _cartItems[menuID]! > 1) {
      _cartItems[menuID] = _cartItems[menuID]! - 1;
      notifyListeners();
    }
  }

  Future addProductToCart({
    required Menus menu,
    required AppLocalizations app,
  }) async {
    isLoading = true;

    try {
      int quantity = await getQuantity(menu.menuID);
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
      _cartItems[menu.menuID] = 1;
      notifyListeners(); // Notify UI about the quantity reset
      Fluttertoast.showToast(msg: app.addedToCart);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isLoading = false;
    }
  }

  // 🔹 Get quantity directly from Firestore data
  int getCartQuantity(String menuID) {
    final menu = _cartMenus.firstWhere(
      (m) => m.menuID == menuID,
    );
    return menu.quantity;
  }

  void addCartQuantity(String menuID) async {
    final menuIndex = _cartMenus.indexWhere((menu) => menu.menuID == menuID);
    if (menuIndex != -1) {
      int newQuantity = _cartMenus[menuIndex].quantity + 1;

      // 🔹 Update Firestore first
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("cart")
          .doc(menuID)
          .update({'quantity': newQuantity}).then((_) {
        // 🔹 Only update locally if Firestore update is successful
        _cartMenus[menuIndex] =
            _cartMenus[menuIndex].copyWith(quantity: newQuantity);
        notifyListeners();
      }).catchError((error) {
        print("Failed to update quantity: $error");
      });
    }
  }

// 🔹 Decrement quantity in Firestore (remove if quantity is 1)
  void removeCartQuantity(String menuID) async {
    final menuIndex = _cartMenus.indexWhere((menu) => menu.menuID == menuID);
    if (menuIndex != -1) {
      int newQuantity = _cartMenus[menuIndex].quantity - 1;

      if (newQuantity > 0) {
        await _firestore
            .collection("users")
            .doc(uid)
            .collection("cart")
            .doc(menuID)
            .update({'quantity': newQuantity}).then((_) {
          // 🔹 Only update locally if Firestore update is successful
          _cartMenus[menuIndex] =
              _cartMenus[menuIndex].copyWith(quantity: newQuantity);
          notifyListeners();
        }).catchError((error) {
          print("Failed to update quantity: $error");
        });
      } else {
        await _firestore
            .collection("users")
            .doc(uid)
            .collection("cart")
            .doc(menuID)
            .delete()
            .then((_) {
          _cartMenus.removeAt(menuIndex);
          notifyListeners();
        }).catchError((error) {
          print("Failed to remove item: $error");
        });
      }
    }
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

  Future deleteProductFromCart({required String menuId}) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("cart")
        .doc(menuId)
        .delete();
  }

  Future sendOrderRequest(
      {required PaymentMethod paymentMethod,
      required Menus model,
      required BuildContext context,
      required String note}) async {
    final ud = uuid.v1();
    print('starting');

    print(address?.toJson().toString());
    print(address);
    OrderRequestModel orderRequestModel = OrderRequestModel(
      id: userProvider.user!.uid!,
      date: DateTime.now().millisecondsSinceEpoch,
      pickupOption: PickupOption.delivery,
      paymentMethod: paymentMethod.toString(),
      address: address,
      userId: userProvider.user?.uid ?? "",
      userName: userProvider.user?.firstName ?? "",
      userImage: userProvider.user?.profileImage ?? "",
      userPhone: userProvider.user?.phoneNumber ?? "",
      userNote: note,
      employeeCancelNote: "",
      deliveryStatus: DeliveryStatus.pending,
      deliveryId: ud,
      deliveryGeoPoint: address?.geoPoint,
      menuTitle: model.menuTitle,
      menuID: model.menuID,
      menuPrice: model.menuPrice,
    );
    await _firestore
        .collection("orders")
        .doc(ud)
        .set(orderRequestModel.toJson());

    final earningsDocRef =
        _firestore.collection("earnings").doc('totalEarnings');
    final earningsSnapshot = await earningsDocRef.get();
    if (earningsSnapshot.exists) {
      double earnings =
          double.parse(earningsSnapshot.data()!["earnings"] ?? '0');
      double totalEarnings = earnings + totalCartPrice;
      await earningsDocRef.update({"earnings": totalEarnings});
    } else {
      await earningsDocRef.set({"earnings": totalCartPrice});
    }
  }

  Future<String> initializeTransaction() async {
    try {
      print("user email ${userProvider.user?.email}");
      final transaction = await Transactions(
          amount: totalCartPrice.toString(),
          reference: DateTime.now().microsecondsSinceEpoch.toString(),
          currency: 'NGN',
          email: userProvider.user!.email!);
      final authResponse = await createTransaction(transaction);
      //return authResponse.authUrl;
      return '${authResponse.authUrl}|${authResponse.reference}';
    } catch (e) {
      print('Error in initializeTransaction: $e');
      return 'payment unsuccessful \n check ur connection';
    }
  }

  Future<PayStackAuthResponse> createTransaction(
      Transactions transaction) async {
    const String url = "https://api.paystack.co/transaction/initialize";
    final data = transaction.toJson();

    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer ${Constants.payStackApiKey}",
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
          'Authorization': 'Bearer ${Constants.payStackApiKey}',
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

  Future<Address> getCordinates() async {
    Address addres = Address();

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
      addres = Address(
          mobile: userProvider.user?.phoneNumber,
          city: city,
          geoPoint: GeoPoin(position.latitude, position.longitude),
          state: pMark.administrativeArea,
          street: pMark.street);

      address = addres;
      fullAddress =
          "${pMark.street}, ${pMark.locality}, ${pMark.administrativeArea}, ${pMark.country}";
    } catch (e) {
      print("location error: ${e.toString()}");
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: 'Check your internet & and allow location permission');
    }

    return addres;
  }

  void getAddressFromCoordinates(
      {required double lat, required double long}) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      if (placemarks.isNotEmpty) {
        Placemark pMark = placemarks.first;
        String? ciy;
        if (pMark.subAdministrativeArea != null) {
          ciy = pMark.subAdministrativeArea;
        } else if (pMark.subLocality != null) {
          ciy = pMark.subLocality!;
        } else if (pMark.locality != null) {
          ciy = pMark.locality!;
        } else {
          // Handle the case where both subLocality and locality are null
          ciy = ""; // Or any default value you prefer
        }
        Address addres = Address(
            mobile: userProvider.user?.phoneNumber,
            city: ciy,
            geoPoint: GeoPoin(lat, long),
            state: pMark.administrativeArea,
            street: pMark.street);

        address = addres;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  double calculateDeliveryFee(double distanceInKm) {
    if (distanceInKm <= 2) {
      return 200; // Nearby delivery
    } else if (distanceInKm <= 5) {
      return 350; // Medium distance
    } else if (distanceInKm <= 10) {
      return 500; // Longer distance
    } else if (distanceInKm <= 20) {
      return 700; // Longer distance
    } else if (distanceInKm <= 30) {
      return 850; // Longer distance
    } else {
      return 1000; // Maximum fee within Lagos
    }
  }
}
