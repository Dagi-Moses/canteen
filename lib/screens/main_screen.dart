import 'package:flutter/material.dart';
import 'package:canteen/screens/cart.dart';
import 'package:canteen/screens/favorite_screen.dart';
import 'package:canteen/screens/home.dart';
import 'package:canteen/screens/notifications.dart';
import 'package:canteen/screens/profile.dart';
import 'package:canteen/screens/search.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/widgets/badge.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";

import '../../models/menus.dart';
import '../providers/app_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final prov = MenuProvider();
  PageController? _pageController;
  int _page = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    CollectionReference cartCollection = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart");
    QuerySnapshot querySnapshot = await cartCollection.get();
    prov.updateCartNo(querySnapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _page == 3
            ? null
            : AppBar(
                backgroundColor: Provider.of<AppProvider>(context).theme ==
                        Constants.lightTheme
                    ? Colors.white
                    : Colors.black,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  app.appName,
                  style: TextStyle(color: Colors.red),
                ),
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    color: Colors.grey,
                    icon: IconBadge(
                      icon: Icons.notifications,
                      size: 22.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Notifications();
                          },
                        ),
                      );
                    },
                    tooltip: app.notification,
                  ),
                ],
              ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            Home(),
            FavoriteScreen(),
            SearchScreen(),
            CartScreen(),
            Profile(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 60,
          surfaceTintColor: Colors.white,
          elevation: 4.0,
          shadowColor: Colors.grey[300],
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 7),
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 24.0,
                ),
                color: _page == 0 ? Colors.red : Colors.grey[600],
                onPressed: () => _pageController!.jumpToPage(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  size: 24.0,
                ),
                color: _page == 1 ? Colors.red : Colors.grey[600],
                onPressed: () => _pageController!.jumpToPage(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 24.0,
                  color: Colors.white,
                ),
                color: _page == 2 ? Colors.red : Colors.grey[600],
                onPressed: () => _pageController!.jumpToPage(2),
              ),
              IconButton(
                icon: IconBadge(
                  icon: Icons.shopping_cart,
                  size: 24.0,
                ),
                color: _page == 3 ? Colors.red : Colors.grey[600],
                onPressed: () => _pageController!.jumpToPage(3),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  size: 24.0,
                ),
                color: _page == 4 ? Colors.red : Colors.grey[600],
                onPressed: () => _pageController!.jumpToPage(4),
              ),
              SizedBox(width: 7),
            ],
          ),
          shape: CircularNotchedRectangle(),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          shape: CircleBorder(),
          elevation: 4.0,
          child: Icon(
            Icons.search,
          ),
          onPressed: () => _pageController!.jumpToPage(2),
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController!.jumpToPage(page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
