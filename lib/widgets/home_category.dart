import 'package:canteen/models/menus.dart';
import 'package:flutter/material.dart';
import 'package:canteen/screens/categories_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';

class HomeCategory extends StatefulWidget {
  final IconData icon;
  final String title;
  final String items;

  bool isSelected;
  Function? onTap;
  final bool isHome;

  HomeCategory({
    Key? key,
    required this.icon,
    required this.title,
    required this.items,
    required this.isHome,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    final menuProvider = Provider.of<MenuProvider>(context, listen: true);
    // int len = menuProvider.menus
    //     .where((menu) => menu.category == widget.title)
    //     .length;
    final len = menuProvider.getMenusListByCategory(widget.title);

    // Filter menus by category directly inside the build method

    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        if (widget.isHome) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return CategoriesScreen(
                  len: len,
                  catie: widget.title,
                );
              },
            ),
          );
        } else {
          menuProvider.updateCategory(widget.title);

          setState(() {});
        }
      },
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        // color: widget.isSelected && !widget.isHome
        //     ? Colors.red.shade100
        //     : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,
        shadowColor: Colors.grey,
        child: Container(
          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 10.0),
                child: Icon(
                  widget.icon,
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                   app.items,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
