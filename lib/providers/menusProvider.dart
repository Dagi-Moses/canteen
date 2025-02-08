import 'package:canteen/models/menus.dart';
import 'package:canteen/util/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {

  MenuProvider() {
    getFavoriteMenus();
    popularMenus();
    recentMenus();
    fetchCartData();
  }

 
  List<Menus>? _menus = [];
  List<Menus>? _cartMenus = [];
  List<Menus>? _categoryMenus = [];

  String _category = '';
  int _cartNo = 0;

  String get category => _category;

  double _totalCartPrice = 0;
  int get cartNo => _cartNo;
  double get totalCartPrice => _totalCartPrice;

  List<Menus>? get menus => _menus;
  List<Menus>? get categoryMenus => _categoryMenus;
  List<Menus>? get cartMenus => _cartMenus;

  Future<List<Menus>>? _favoritesFuture;
  Future<List<Menus>>? _popularMenusFuture;
  Future<List<Menus>>? _recentMenusFuture;
  Future<List<Menus>>? _cartMenusFuture;

  
  Future<List<Menus>>? get favoritesFuture => _favoritesFuture;
  Future<List<Menus>>? get popularMenusFuture => _popularMenusFuture;
  Future<List<Menus>>? get recentMenusFuture => _recentMenusFuture;
  Future<List<Menus>>? get cartMenusFuture => _cartMenusFuture;


Future<void> fetchCartData() async {
    CollectionReference cartCollection = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart");
    QuerySnapshot querySnapshot = await cartCollection.get();
    updateCartNo(querySnapshot.docs.length);
  }
   Future<void>  popularMenus() async {

     try {
      _popularMenusFuture = FirebaseFirestore.instance
          .collection('menus')
          .orderBy('likesCount', descending: true)
          .limit(10)
          .get()
          .then((snapshot) => snapshot.docs
              .map((doc) => Menus.fromJson(json: doc.data()))
              .toList());
      notifyListeners();
    } catch (e) {
      print('Error fetching menus: $e');
      _popularMenusFuture = Future.value([]); // Handle errors gracefully
      notifyListeners();
    }
   
  }

   Future<void> recentMenus()  async {

     try {
      _recentMenusFuture = FirebaseFirestore.instance
          .collection('menus')
          .orderBy('publishDate', descending: true)
          .get()
          .then((snapshot) => snapshot.docs
              .map((doc) => Menus.fromJson(json: doc.data()))
              .toList());
      notifyListeners();
    } catch (e) {
      print('Error fetching menus: $e');
      _recentMenusFuture = Future.value([]); // Handle errors gracefully
      notifyListeners();
    }
   
  }

  Future<void> refreshHomeMenuData() async {
    popularMenus();
    recentMenus();
  }



  Future<void> getFavoriteMenus() async {
    try {
      _favoritesFuture = FirebaseFirestore.instance
          .collection('menus')
          .where('likes', arrayContains: uid)
          .get()
          .then((snapshot) => snapshot.docs
              .map((doc) => Menus.fromJson(json: doc.data()))
              .toList());
      notifyListeners();
    } catch (e) {
      print('Error fetching menus: $e');
      _favoritesFuture = Future.value([]); // Handle errors gracefully
      notifyListeners();
    }
  }




  set menus(List<Menus>? menus) {
    _menus = menus;

    notifyListeners();
  }

  void updateMenus(List<Menus>? updatedMenus) {
    _menus = updatedMenus;

    notifyListeners();
  }

  void updateCartMenusFromSnapshot(QuerySnapshot snapshot) {
    final updatedMenus = snapshot.docs.map((doc) {
      return Menus.fromJson(json: doc.data() as Map<String, dynamic>);
    }).toList();

    double total = 0.0;
    for (Menus cartMenu in updatedMenus) {
      total += cartMenu.menuPrice + 500;
    }
    _cartMenus = updatedMenus;
    _totalCartPrice = total;
    _cartNo = updatedMenus.length;
    notifyListeners();
  }

  int? getMenusListByCategory(String category) {
    int? categoryLength =
        _menus?.where((menu) => menu.category == category).length;

    // Notify listeners when the state changes
    notifyListeners();

    return categoryLength;
  }

  void updateCartNo(int No) {
    _cartNo = No;
    notifyListeners();
  }

  void minusCartNo() {
    _cartNo = _cartNo - 1;
    notifyListeners();
  }

  void updateCategory(String newCategory) {
    _category = newCategory;
    _categoryMenus =
        _menus?.where((menu) => menu.category == newCategory).toList();
    notifyListeners(); // Notify listeners when the state changes
  }
}
