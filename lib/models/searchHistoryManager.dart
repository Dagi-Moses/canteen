import 'dart:convert';

import 'package:canteen/util/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menus.dart';

class SearchManager {
  static const String _historyKey = 'search_history';

  void saveMenusToSharedPreferences(Menus menu) async {
    List<String>? existingMenusJson = prefs.getStringList(_historyKey);
    List<Map<String, dynamic>> existingMenus = [];

    if (existingMenusJson != null) {
      existingMenus = existingMenusJson
          .map((json) => jsonDecode(json))
          .cast<Map<String, dynamic>>()
          .toList();
    }
    existingMenus.add(menu.toJson());
    List<String> updatedMenusJson = existingMenus.map((json) {
      // json['publishDate'] = (json['publishDate'] as DateTime).toIso8601String();
      if (json['publishDate'] is DateTime) {
        json['publishDate'] =
            (json['publishDate'] as DateTime).toIso8601String();
      }
      return jsonEncode(json);
    }).toList();

    prefs.setStringList(_historyKey, updatedMenusJson);
  }

  Future<List<Menus>> getMenusFromSharedPreferences() async {
    List<String>? existingMenusJson = prefs.getStringList(_historyKey);
    List<Menus> menusList = [];

    if (existingMenusJson != null) {
      for (String json in existingMenusJson) {
        Map<String, dynamic> menuMap = jsonDecode(json);

        // Convert "publishDate" to timestamp before using Menus.fromJson
        if (menuMap['publishDate'] is String) {
          menuMap['publishDate'] =
              Timestamp.fromDate(DateTime.parse(menuMap['publishDate']));
        }

        Menus menu = Menus.fromJson(json: menuMap);
        menusList.add(menu);
      }
    }

    return menusList;
  }

  Future<void> deleteMenuFromSharedPreferences(String menuTitle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? menusJson = prefs.getStringList(_historyKey);

    if (menusJson != null) {
      List<Map<String, dynamic>> decodedMenus = menusJson
          .map((json) => jsonDecode(json))
          .cast<Map<String, dynamic>>()
          .toList();

      decodedMenus.removeWhere(
          (menuJson) => Menus.fromJson(json: menuJson).menuTitle == menuTitle);

      prefs.setStringList(
        _historyKey,
        decodedMenus.map((json) => jsonEncode(json)).toList(),
      );
    }
  }
}
