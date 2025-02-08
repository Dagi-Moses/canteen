import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
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
}
