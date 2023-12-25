import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canteen/widgets/grid_product.dart';


import '../../models/menus.dart';
import '../util/const.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    {
  @override
  Widget build(BuildContext context) {
     final app = AppLocalizations.of(context)!;
    
   
    return Scaffold(
      body: Padding(
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
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('menus')
                    .where('likes', arrayContains: uid)
                    .snapshots(),
                builder: (context, snapshot) {
                 

                  return GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.25),
                      ),
                      itemCount:
                          snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                    Menus menu = Menus.fromJson(
                        json: document.data() as Map<String, dynamic>);

                    return GridProduct(
                      model: menu,
                    );
                      });
                }),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

}
