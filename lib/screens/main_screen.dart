 import 'package:canteen/models/menus.dart';
import 'package:canteen/providers/app_provider.dart';
import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/screens/account%20screen.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/badge.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:canteen/screens/cart.dart';
import 'package:canteen/screens/favorite_screen.dart';
import 'package:canteen/screens/home.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/screens/search.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final PageController _pageController = PageController();
  int _currentPage = 0;

  
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set your desired status bar color
      // Set your desired navigation bar color
    ));
  
  }

  

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    final menus = Provider.of<MenuProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          app.appName,
          style: TextStyle(color: Colors.red),
        ),
       // toolbarHeight: 0,
        backgroundColor:
            Provider.of<AppProvider>(context).theme == Constants.lightTheme
                ? Colors.white
                : Colors.black,
        elevation: 0,
        actions: _currentPage != 3
            ?<Widget>[
                  IconButton(
                    color: Colors.grey,
                    icon: IconBadge(
                      data: menus.cartNo,
                      icon: Icons.notifications,
                      size: 22.0,
                    ),
                    onPressed: () {
                     Navigator.of(context).pushNamed(Routes.notifications);
                    },
                    tooltip: app.notification,
                  ),
                ]
            : null,
      ),
      body: ScreenHelper(
        mobile: _buildMobileLayout(),
        tablet: _buildLayout(menus),
        desktop: _buildLayout(menus),
      ),
    
        bottomNavigationBar: ScreenHelper.isMobile(context)
          ?BottomAppBar(
          height: 60,
          surfaceTintColor: Colors.white,
          elevation: 4.0,
          shadowColor: Colors.grey[300],
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _bottomNavIcons(menus),
          ),
          shape: CircularNotchedRectangle(),
        )
          : null,
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      
      floatingActionButton: ScreenHelper.isMobile(context)
          ? FloatingActionButton(  
           // mini: true, // Makes it a smaller circle
             
              shape: CircleBorder(),
              backgroundColor: _currentPage==2? Colors.red : Colors.grey[600],
              onPressed: () => _onNavigationChanged(2),
              child: Icon(Icons.search ,),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildMobileLayout() {
    return PageView(
      controller: _pageController,

      physics: NeverScrollableScrollPhysics(),
      children:  [
     

        Home(),
        FavoriteScreen(),
        SearchScreen(),
       CartScreen(),
        SettingsScreen(),

       // Profile(),
      
      ],
    );
  }


  Widget _buildLayout(MenuProvider menus) {
    return Row(
      children: [
        NavigationRail(
          
          selectedIndex: _currentPage,
          onDestinationSelected: _onNavigationChanged,
          labelType: NavigationRailLabelType.all,
          indicatorColor: Colors.red,
       //   unselectedIconTheme: IconThemeData(color: Colors.grey[600]) ,
          
          destinations: _navigationDestinations(menus),
        ),
        Expanded(
          child: _buildMobileLayout(),
        ),
      ],
    );
  }

  List<Widget> _bottomNavIcons(MenuProvider menus) {
    final icons = [
      Icons.home,
      Icons.favorite,
      Icons.search,
      Icons.shopping_cart,
      Icons.person,
    ];

    return List.generate(icons.length, (index) {
      final isSelected = _currentPage == index;
      return IconButton(
        
        icon: index == 3
            ? IconBadge(icon: icons[index] , data : menus.cartNo )
            : Icon(icons[index], size: 24.0,  color: index == 2
                    ? Theme.of(context).primaryColor
                    : (isSelected ? Colors.red : Colors.grey[600]),
              ),
        color: isSelected ? Colors.red : Colors.grey[600],
        onPressed: () => _onNavigationChanged(index),
      );
    });
  }



  List<NavigationRailDestination> _navigationDestinations(MenuProvider menus) {
    return [
      NavigationRailDestination(
       
        icon: Icon(Icons.home), label: Text("Home")),
      NavigationRailDestination(
          icon: Icon(Icons.favorite), label: Text("Favorites")),
      NavigationRailDestination(
          icon: Icon(Icons.search), label: Text("Search")),
           NavigationRailDestination(
          icon: IconBadge(icon: Icons.shopping_cart, size: 24.0, data: menus.cartNo ,), label: Text("Cart")),
      // NavigationRailDestination(
      //     icon: Icon(Icons.shopping_cart), label: Text("Cart")),
      NavigationRailDestination(
          icon: Icon(Icons.person), label: Text("Profile")),
    ];
  }

  void _onNavigationChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
