import 'package:canteen/models/menus.dart';
import 'package:flutter/material.dart';
import 'package:canteen/screens/notifications.dart';


import 'package:canteen/widgets/badge.dart';
import 'package:canteen/widgets/grid_product.dart';
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
        .updateCategory(widget.catie);
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
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              height: 65.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: app.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = app.categories[index];
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
            Text(
              "${menuProvider.category}",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            Divider(),
            SizedBox(height: 10.0),
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: menuProvider.categoryMenus.length,
              itemBuilder: (BuildContext context, int index) {
                final food = menuProvider.categoryMenus[index];
                // Menus Menu = Menus.fromJson(json: food as Map<String, dynamic>)  ;
                return GridProduct(
                  model: food,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
