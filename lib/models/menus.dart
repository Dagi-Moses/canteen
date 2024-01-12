import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Menus {
  final String menuID;
  final String menuTitle;

  final String menuInfo;
  final int menuPrice;
  final DateTime publishDate;
  final String thumbnailUrl;
  final String status;
  final double rating;
  final List likes;
  final int likesCount;
  final List raters;
  final String category;

  Menus({
    required this.likesCount,
    required this.menuID,
    required this.menuInfo,
    required this.menuTitle,
    required this.menuPrice,
    required this.category,
    required this.publishDate,
    required this.status,
    required this.rating,
    required this.raters,
    required this.likes,
    required this.thumbnailUrl,
  });

  factory Menus.fromJson({required Map<String, dynamic> json}) {
    return Menus(
      menuID: json["menuID"],
      menuPrice: json["menuPrice"],
      menuInfo: json["menuInfo"],
      menuTitle: json["menuTitle"],
      publishDate: json['publishDate'].toDate(),
      status: json["status"],
      rating: json['rating'],
      raters: json['raters'],
      likes: json['likes'],
      thumbnailUrl: json["thumbnailUrl"],
      category: json['category'],
      likesCount: json['likesCount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['title'] = menuTitle.toLowerCase();
    data['likesCount'] = likesCount;
    data["menuID"] = menuID;
    data["menuPrice"] = menuPrice;
    data["menuInfo"] = menuInfo;
    data["menuTitle"] = menuTitle;
    data["publishDate"] = publishDate;
    data["status"] = status;
    data['rating'] = rating;
    data['raters'] = raters;
    data['likes'] = likes;
    data['category'] = category;
    data["thumbnailUrl"] = thumbnailUrl;
    return data;
  }
}

class MenuProvider extends ChangeNotifier {
  List<Menus> _menus = [];
  List<Menus> _cartMenus = [];
  List<Menus> _categoryMenus = [];
  String _category = '';
  int _cartNo = 0;

  String get category => _category;

  double _totalCartPrice = 0;
  int get cartNo => _cartNo;
  double get totalCartPrice => _totalCartPrice;

  List<Menus> get menus => _menus;
  List<Menus> get categoryMenus => _categoryMenus;
  List<Menus> get cartMenus => _cartMenus;

  set menus(List<Menus> menus) {
    _menus = menus;

    notifyListeners();
  }

  void updateMenusFromSnapshot(QuerySnapshot snapshot) {
    final updatedMenus = snapshot.docs.map((doc) {
      return Menus.fromJson(json: doc.data() as Map<String, dynamic>);
    }).toList();

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
    _cartNo = updatedMenus.length ;
    notifyListeners();
  }

  int getMenusListByCategory(String category) {
    int categoryLength =
        _menus.where((menu) => menu.category == category).length;

    // Notify listeners when the state changes
    notifyListeners();

    return categoryLength;
  }
  void updateCartNo(int No){
    _cartNo = No;
   notifyListeners();
  }
  void minusCartNo(){
    _cartNo = _cartNo -1;
    notifyListeners();
  }

  void updateCategory(String newCategory) {
    _category = newCategory;
    _categoryMenus =
        _menus.where((menu) => menu.category == newCategory).toList();
    notifyListeners(); // Notify listeners when the state changes
  }
}
