import 'package:canteen/providers/app_provider.dart';
import 'package:canteen/providers/cartProvider.dart';
import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/providers/navigationProvider.dart';
import 'package:canteen/screens/account%20screen.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/badge.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
 late AppLocalizations app;
 late  CartProvider cartMenus;
 late  MenuProvider menus;
 late NavigationProvider navigationProvider;
 
@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Adjust if needed
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
     app = AppLocalizations.of(context)!;
    cartMenus = Provider.of<CartProvider>(context);
     menus = Provider.of<MenuProvider>(context);
   navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
       resizeToAvoidBottomInset: false, 
      appBar: navigationProvider.currentPage == 4
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                app.appName,
                style: TextStyle(color: Colors.red),
              ),
              // toolbarHeight: 0,
              backgroundColor: Provider.of<AppProvider>(context).theme ==
                      Constants.lightTheme
                  ? Colors.white
                  : Colors.black,
              elevation: 0,
              actions: navigationProvider.currentPage != 3
                  ? <Widget>[
                      IconButton(
                        color: Colors.grey,
                        icon: IconBadge(
                          data: cartMenus.cartNo,
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
      body:  Builder(
  builder: (context) {
    return ScreenHelper(
      mobile: _buildMobileLayout(navigationProvider),
      tablet: _buildLayout(menus, navigationProvider, cartMenus),
      desktop: _buildLayout(menus, navigationProvider, cartMenus),
    );
  },
),

      bottomNavigationBar: ScreenHelper.isMobile(context)
          ? BottomAppBar(
              height: 60,
              surfaceTintColor: Colors.white,
              elevation: 4.0,
              shadowColor: Colors.grey[300],
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _bottomNavIcons(menus, navigationProvider, cartMenus),
              ),
              shape: CircularNotchedRectangle(),
            )
          : null,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: ScreenHelper.isMobile(context)
          ? FloatingActionButton(
              // mini: true, // Makes it a smaller circle

              shape: CircleBorder(),
              backgroundColor:
                  navigationProvider.currentPage == 2 ? Colors.red : Colors.grey[600],
              onPressed: () => navigationProvider.changePage(2),
              child: Icon(
                Icons.search,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildMobileLayout(NavigationProvider navigationProvider) {
    return PageView(
      controller: navigationProvider.pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Home(),
        FavoriteScreen(),
        SearchScreen(),
        CartScreen(),
        SettingsScreen(),

      ],
    );
  }

  Widget _buildLayout(MenuProvider menus, NavigationProvider navigationProvider, CartProvider cart) {
    return Row(
      children: [
        NavigationRail(
          
          selectedIndex: navigationProvider.currentPage,
          onDestinationSelected: navigationProvider.changePage,
          labelType: NavigationRailLabelType.all,
          indicatorColor: Colors.red,
          //   unselectedIconTheme: IconThemeData(color: Colors.grey[600]) ,

          destinations: _navigationDestinations(menus, cart),
        ),
        Expanded(
          child: _buildMobileLayout(navigationProvider),
        ),
      ],
    );
  }

  List<Widget> _bottomNavIcons(MenuProvider menus,  NavigationProvider navigationProvider, CartProvider cart) {
    final icons = [
      Icons.home,
      Icons.favorite,
      Icons.search,
      Icons.shopping_cart,
      Icons.person,
    ];

    return List.generate(icons.length, (index) {
      final isSelected = navigationProvider.currentPage == index;
      return IconButton(
        icon: index == 3
            ? IconBadge(icon: icons[index], data:cart.cartNo)
            : Icon(
                icons[index],
                size: 24.0,
                color: index == 2
                    ? Theme.of(context).primaryColor
                    : (isSelected ? Colors.red : Colors.grey[600]),
              ),
        color: isSelected ? Colors.red : Colors.grey[600],
        onPressed: () {navigationProvider.changePage(index);},
      );
    });
  }

  List<NavigationRailDestination> _navigationDestinations(MenuProvider menus, CartProvider cart) {
    return [
      NavigationRailDestination(icon: Icon(Icons.home), label: Text(app.home)),
      NavigationRailDestination(
          icon: Icon(Icons.favorite), label: Text(app.favorites)),
      NavigationRailDestination(
          icon: Icon(Icons.search), label: Text(app.search)),
      NavigationRailDestination(
          icon: IconBadge(
            icon: Icons.shopping_cart,
            size: 24.0,
            data: cart.cartNo,
          ),
          label: Text(app.cart)),
      // NavigationRailDestination(
      //     icon: Icon(Icons.shopping_cart), label: Text("Cart")),
      NavigationRailDestination(
          icon: Icon(Icons.person), label: Text(app.profile)),
    ];
  }


}
