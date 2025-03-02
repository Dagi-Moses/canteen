import 'dart:async';

import 'package:canteen/models/menus.dart';
import 'package:canteen/models/searchHistoryManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  final SearchManager _history = SearchManager();
  final TextEditingController searchControl = TextEditingController();
  final fire = FirebaseFirestore.instance;
  final FocusNode focusNode = FocusNode();
  List<Menus> searchResults = [];
  Timer? _debounce;

  SearchProvider() {
    searchControl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _updateSearchResults(searchControl.text);
    });
  }

  Future<void> _updateSearchResults(String searchText) async {
    if (searchText.isNotEmpty) {
      QuerySnapshot snapshot = await fire
          .collection('menus')
          .where(
            'title',
            isGreaterThanOrEqualTo: searchText.toLowerCase(),
          )
          .where(
            'title',
            isLessThan: searchText.toLowerCase() + '\uf8ff',
          )
          .get();

      searchResults = snapshot.docs
          .map(
              (doc) => Menus.fromJson(json: doc.data() as Map<String, dynamic>))
          .where((menu) =>
              menu.menuTitle.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    } else {
      searchResults.clear();
    }
    notifyListeners();
  }

  Future<List<Menus>> getSearchHistory() async {
    return await _history.getMenusFromSharedPreferences();
  }

  void deleteHistoryItem(String title) {
    _history.deleteMenuFromSharedPreferences(title);
    notifyListeners();
  }

  @override
  void dispose() {
    searchControl.dispose();
   focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
