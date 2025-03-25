import 'dart:async';

import 'package:canteen/admin/screens/history_screen.dart';
import 'package:canteen/admin/screens/home_screen.dart';

import 'package:canteen/admin/upload_screens/menus_upload_screen.dart';
import 'package:canteen/admin/widgets/dashboardWidget.dart';
import 'package:canteen/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Set the color of the status bar and navigation bar for this screen only
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Color.fromARGB(255, 51, 12, 12), // Set your desired status bar color
      systemNavigationBarColor: Color.fromARGB(
          255, 51, 12, 12), // Set your desired navigation bar color
    ));
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..forward();
    animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    Timer(Duration(seconds: 3), () {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  List cat = [
    {"name": "Menus", "icon":  Icons.fastfood, "nav": HomeScreen()},
    {"name": "Orders", "icon": Icons.shopping_cart, "nav": HistoryScreen()},
    {
      "name": "View Users App",
      "icon": Icons.person,
      "nav": MainScreen()
    },
    {
      "name": "Upload Menu",
      "icon": Icons.add,
      "nav": MenusUploadScreen()
    },
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final app = AppLocalizations.of(context)!;
    return Scaffold(
      key: _key,
      backgroundColor: Color.fromARGB(255, 51, 12, 12),
      body: Container(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ScaleTransition(
              scale: animation,
              child: Container(
                height: size.height,
                width: size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Welcome Admin',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                       
                        itemCount: 4,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> categories = cat[index];
                          return DashBoardWidget(
                            index: index,
                            cat: categories,
                          );
                        }),
                        SizedBox()
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
