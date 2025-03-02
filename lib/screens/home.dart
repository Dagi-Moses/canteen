import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/util/categories.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/widgets/placeHolders.dart/custom_image_placeholder.dart';
import 'package:canteen/widgets/menuGridFutureBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';



import 'package:canteen/widgets/home_category.dart';

import 'package:canteen/widgets/slider_item.dart';

import 'package:carousel_slider/carousel_slider.dart';


import 'package:provider/provider.dart';

import '../models/menus.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// Inside your state class



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
 late ScrollController _scrollController = ScrollController();

 
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
   final menuProvider = Provider.of<MenuProvider>(context);
    final app = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body:  RefreshIndicator(
        onRefresh:  ()async {
          menuProvider.fetchMenus();
        },
        child: SingleChildScrollView(
        
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
             Consumer<MenuProvider>(
                  builder: (context, menuProvider, child) {
         if (menuProvider.isLoading) {
                      return Expanded(
                        // height: MediaQuery.of(context).size.height /
                        //     2.1, // Same height as CarouselSlider
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                ScreenHelper.isMobile(context) ? 1 : 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio:
                                3 / 2, // Adjust for carousel item proportions
                          ),
                          itemCount: ScreenHelper.isMobile(context) ? 1 : 3,
                          itemBuilder: (context, index) {
                                double scale = index == 1 ? 1.0 : 0.8; // 1.0 for center, 0.8 for others
                            return Transform.scale(
                                       scale: scale,
                              child: CustomImagePlaceHolderWidget()
                            );
                          },
                        ),
                      );
                    }  else if (menuProvider.popularMenus.isEmpty) {
        return SizedBox();
            } else {
        // Using CarouselSlider with the fetched menus
        final carouselItems = menuProvider.popularMenus.map((menu) {
          return SliderItem(
            model: menu,
            menuProvider: menuProvider,
          
          );
        }).toList();
        
        return CarouselSlider(
        
          options: CarouselOptions(
          
            autoPlay: true,
            enableInfiniteScroll: true,
            enlargeCenterPage: true, // Increase the size of the center item
            autoPlayInterval: Duration(seconds: 10), // Set auto-play interval
            autoPlayAnimationDuration: Duration(seconds: 2), // Set animation duration
            autoPlayCurve: Curves.fastOutSlowIn, // Set animation curve
            height: MediaQuery.of(context).size.height / 2.1,
            viewportFraction: ScreenHelper.isMobile(context) ? 1.0 : 0.3,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              // SchedulerBinding.instance.addPostFrameCallback((_) {
              //   setState(() {
              //     _current = index;
              //   });
              // });
            },
          ),
          items: carouselItems,
        );
            }
          },
        ),
        
        
             
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
                   alignment: Alignment.centerLeft,
                  height: 65.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: categories(context).length,
                    itemBuilder: (BuildContext context, int index) {
                      Map cat = categories(context)[index];
        
                      return HomeCategory(
                        icon: cat['icon'],
                        title: cat['name'],
                        items: cat['items'].toString(),
                        isHome: true,
                      );
                    },
                  ),
                ),
        
                SizedBox(height:ScreenHelper.isMobile(context)?  20.0: 40),
        
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
            MenuGridFutureBuilder( menuProvider: menuProvider, menus: menuProvider.recentMenus, ),
                
        
        
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
