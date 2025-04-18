import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/menuWidgets/slider_item.dart';
import 'package:flutter/material.dart';
import 'package:canteen/util/foods.dart';
import 'package:canteen/widgets/badge.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../models/menus.dart';


class DishesScreen extends StatefulWidget {
  @override
  _DishesScreenState createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {
  @override
  Widget build(BuildContext context) {
       final menuProvider = Provider.of<MenuProvider>(context);
    final app = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: ()=>Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          app.dishes,
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              data: 111,
              icon: Icons.notifications,
              size: 22.0,
            ),
            onPressed: (){
              Navigator.pushNamed(
                context,
                Routes.notifications,
              );
             
            },
          ),
        ],
      ),

      body: Padding(
          padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(

          children: <Widget>[
            Text(
              app.chinese,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            Divider(),

            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
              Map food = foods[index];
                Menus menu = Menus.fromJson(json: food as Map<String, dynamic>);
                return SliderItem(
                  menuProvider: menuProvider,
                model: menu,
               
                );
              },
            ),

            SizedBox(height: 20.0),
            Text(
              app.italian,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            Divider(),

            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
               Map food = foods[index];
                Menus menu = Menus.fromJson(json: food as Map<String, dynamic>);
                return SliderItem(
                  menuProvider: menuProvider,
                model: menu,
              
                );
              },
            ),

            SizedBox(height: 20.0),
            Text(
              app.african,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            Divider(),

            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                Map food = foods[index];
                Menus menu = Menus.fromJson(json: food as Map<String, dynamic>);
                return SliderItem(
                  menuProvider: menuProvider,
                model: menu,
                
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
