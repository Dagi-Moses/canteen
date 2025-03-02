import 'package:canteen/models/menus.dart';
import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/util/categories.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/menuGridFutureBuilder.dart';
import 'package:canteen/widgets/slider_item.dart';
import 'package:flutter/material.dart';



import 'package:canteen/widgets/badge.dart';

import 'package:canteen/widgets/home_category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';


class CategoriesScreen extends StatefulWidget {
  String catie;
  int len;

  CategoriesScreen({
    super.key,
    required this.catie,
    required this.len,
  });
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MenuProvider>(context, listen: false)
        .category = widget.catie;
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: true);
      final app = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          app.categoriess,
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              data: 111,
              icon: Icons.notifications,
              size: 22.0,
            ),
            onPressed: () {
                Navigator.pushNamed(context, Routes.notifications);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.center,
              height: 65.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories(context).length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories(context)[index];
                  bool isSelected = cat['name'] == menuProvider.category;
                  return HomeCategory(
               
                    isSelected:isSelected,  
                    icon: cat['icon'],
                    title: cat['name'],
                    items: cat['items'].toString(),
                    isHome: false,
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "${menuProvider.category}",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            SizedBox(height: 10.0),
            Center(child: MenuGridFutureBuilder(menus: menuProvider.categoryMenus, menuProvider: menuProvider))
            // GridView.builder(
            //   shrinkWrap: true,
            //   primary: false,
            //   physics: NeverScrollableScrollPhysics(),
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //   crossAxisSpacing: 10,
            //     childAspectRatio: MediaQuery.of(context).size.width /
            //         (MediaQuery.of(context).size.height / 1.25),
            //   ),
            //   itemCount: menuProvider.categoryMenus.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     final food = menuProvider.categoryMenus[index];
            //     // Menus Menu = Menus.fromJson(json: food as Map<String, dynamic>)  ;
            //     return SliderItem(
            //       menuProvider: menuProvider,
            //       model: food,
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
