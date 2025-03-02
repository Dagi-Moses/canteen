import 'package:canteen/models/menus.dart';
import 'package:canteen/models/review.dart';
import 'package:canteen/util/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  MenuProvider() {
    fetchMenus();
  }

  List<Menus> _menus = [];

  String _category = ''; // Default category

  String get category => _category;

  set category(String newCategory) {
    if (_category != newCategory) {
      _category = newCategory;
      notifyListeners(); // ✅ Notify UI to refresh `categoryMenus`
    }
  }

  List<Menus> get menus => _menus;
  set menus(List<Menus> value) {
    _menus = value;
    notifyListeners();
  }

  List<Menus> get categoryMenus =>
      _menus.where((menu) => menu.category == category).toList();

  List<Menus> get favoriteMenus =>
      _menus.where((menu) => menu.likes.contains(uid)).toList();

  List<Menus> get popularMenus {
    List<Menus> sortedMenus =
        List.from(_menus); // Create a copy to avoid modifying the original list
    sortedMenus.sort(
        (a, b) => b.likes.length.compareTo(a.likes.length)); // Sort descending
    return sortedMenus.take(10).toList(); // Limit to 10 items
  }

  List<Menus> get recentMenus => _menus.toList()
    ..sort((a, b) => b.publishDate.compareTo(a.publishDate)); // Sort descending

  List<Menus> getCategoryMenus(String category) =>
      _menus.where((menu) => menu.category == category).toList();

  Future<void> fetchMenus() async {
    try {
      final snapshot = await _firestore.collection('menus').get();
      menus =
          snapshot.docs.map((doc) => Menus.fromJson(json: doc.data())).toList();
    } catch (e) {
      print('Error fetching menus: $e');
    }

    isLoading = false;
  }

  void updateMenus(List<Menus> updatedMenus) {
    _menus = updatedMenus;

    notifyListeners();
  }

  int? getMenusListByCategory(String category) {
    int? categoryLength =
        _menus.where((menu) => menu.category == category).length;

    // Notify listeners when the state changes
    notifyListeners();

    return categoryLength;
  }

  Future<void> likePost({
    required String menuId,
    required List likes,
  }) async {
    int index = _menus.indexWhere((menu) => menu.menuID == menuId);
    if (index == -1) return;

    // ✅ Optimistically update UI
    bool isLiked = likes.contains(uid);
    List updatedLikes = List.from(likes);

    if (isLiked) {
      updatedLikes.remove(uid);
    } else {
      updatedLikes.add(uid);
    }

    Menus previousMenu = _menus[index]; // Save old state in case of failure
    Menus updatedMenu = _menus[index].copyWith(likes: updatedLikes);
    _menus[index] = updatedMenu;
    notifyListeners(); // UI updates immediately

    try {
      // ✅ Update Firebase
      await _firestore.collection('menus').doc(menuId).update({
        'likes': isLiked
            ? FieldValue.arrayRemove([uid])
            : FieldValue.arrayUnion([uid]),
      });
    } catch (err) {
      print("Error liking post: $err");

      // 🔄 Revert changes if Firebase fails
      _menus[index] = previousMenu;
      notifyListeners();
    }
  }

  Future uploadReview({
    required Review model,
    required Menus menu,
  }) async {
    try {
      // Add review to Firestore
      await _firestore
          .collection("menus")
          .doc(menu.menuID)
          .collection("reviews")
          .add(model.getJson());

      // Update rating in Firestore and locally
      await changeAverageRating(reviewModel: model, menu: menu);

      // 🔥 Find the menu in `_menus` and update it locally
      int index = _menus.indexWhere((m) => m.menuID == menu.menuID);
      if (index != -1) {
        Menus updatedMenu = _menus[index].copyWith(
          raters: [..._menus[index].raters, uid], // Add rater
        );
        _menus[index] = updatedMenu;
        notifyListeners(); // 🚀 Notify UI of the change
      }
    } catch (e) {
      print("Error uploading review: $e");
    }
  }

  Future changeAverageRating({
    required Review reviewModel,
    required Menus menu,
  }) async {
    try {
      // Fetch latest menu data from Firestore
      DocumentSnapshot snapshot =
          await _firestore.collection("menus").doc(menu.menuID).get();

      Menus model = Menus.fromJson(json: (snapshot.data() as dynamic));
      double currentRating = model.rating;
      double userRating = reviewModel.rating;
      int currentRaters = model.raters.length;

      // Calculate new average rating
      double newRating =
          ((currentRating * currentRaters) + userRating) / (currentRaters + 1);

      // Update rating in Firestore
      await _firestore.collection("menus").doc(menu.menuID).update({
        "rating": newRating,
      });
      if (!menu.raters.contains(uid)) {
        _firestore.collection('menus').doc(menu.menuID).update({
          'raters': FieldValue.arrayUnion([uid])
        });
      }

      // 🔥 Update `_menus` locally
      int index = _menus.indexWhere((m) => m.menuID == menu.menuID);
      if (index != -1) {
        Menus updatedMenu = _menus[index].copyWith(
          rating: newRating,
          raters: menu.raters.contains(uid)
              ? _menus[index].raters
              : [..._menus[index].raters, uid],
        );
        _menus[index] = updatedMenu;
        notifyListeners(); // 🚀 Refresh UI
      }
    } catch (e) {
      print("Error updating rating: $e");
    }
  }
}
