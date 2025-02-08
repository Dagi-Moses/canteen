import 'package:canteen/providers/menusProvider.dart';

import 'package:canteen/widgets/menuGridFutureBuilder.dart';


import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';




class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    {



  
  @override
  Widget build(BuildContext context) {
     final menuProvider = Provider.of<MenuProvider>(context);
     final app = AppLocalizations.of(context)!;
    
   
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: menuProvider.getFavoriteMenus,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(
                app.myFavoriteItems,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.0),
                  MenuGridFutureBuilder(
                future: menuProvider.favoritesFuture!,
             
              ),
              
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

}
