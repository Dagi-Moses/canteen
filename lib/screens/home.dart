import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:canteen/widgets/grid_product.dart';

import 'package:canteen/widgets/home_category.dart';

import 'package:canteen/widgets/slider_item.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';

import '../models/menus.dart';

import '../util/const.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];

    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    int _current = 0;
    final app = AppLocalizations.of(context)!;
 final menuProvider = Provider.of<MenuProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    app.popularItems,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox()
                ],
              ),

              SizedBox(height: 10.0),

              //Slider Here

              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('menus')
                      .orderBy('likesCount', descending: true)
                      .limit(10)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final carouselItems =
                        List.generate(snapshot.data!.docs.length, (index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];

                      Menus menu = Menus.fromJson(
                          json: document.data() as Map<String, dynamic>);

                      return SliderItem(
                        model: menu,
                        isFav: menu.likes.contains(uid),
                      );
                    }).toList();

                    return CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage:
                            true, // Increase the size of the center item

                        autoPlay: true, // Enable auto-play

                        autoPlayInterval:
                            Duration(seconds: 20), // Set auto-play interval

                        autoPlayAnimationDuration:
                            Duration(seconds: 2), // Set animation duration

                        autoPlayCurve: Curves.fastOutSlowIn,

                        // Set animation curve

                        height: MediaQuery.of(context).size.height / 2.4,

                        viewportFraction: 1.0,

                        aspectRatio: 2.0,

                        onPageChanged: (index, reason) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _current = index;
                            });
                          });
                        },
                      ),
                      items: carouselItems,
                    );
                  }),

              SizedBox(height: 20.0),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  app.foodCategories,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              SizedBox(height: 10.0),

              Container(
                height: 65.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: app.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map cat = app.categories[index];
                    List<Menus> filteredMenus = menuProvider.menus
                        .where((menu) => menu.category == cat['name'])
                        .toList();

                    int len = filteredMenus.length;

                    return HomeCategory(
                      len: len,
                      icon: cat['icon'],
                      title: cat['name'],
                      items: cat['items'].toString(),
                      isHome: true,
                    );
                  },
                ),
              ),

              SizedBox(height: 20.0),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  app.dishes,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              SizedBox(height: 10.0),

              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('menus')
                      .orderBy('publishDate', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return CircularProgressIndicator
                          .adaptive(); // Replace this with your preferred loading widget
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.25),
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Provider.of<MenuProvider>(context, listen: false)
                            .updateMenusFromSnapshot(
                                snapshot.data as QuerySnapshot);

                        DocumentSnapshot document = snapshot.data!.docs[index];

                        Menus menu = Menus.fromJson(
                            json: document.data() as Map<String, dynamic>);

                        return GridProduct(
                          model: menu,
                        );
                      },
                    );
                  }),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
