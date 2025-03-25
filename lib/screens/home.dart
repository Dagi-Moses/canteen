import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/util/categories.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/widgets/menuWidgets/menuGridFutureBuilder.dart';
import 'package:canteen/widgets/menuWidgets/slider_item.dart';
import 'package:canteen/widgets/placeHolders.dart/custom_image_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:canteen/widgets/home_category.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  
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
                      return SizedBox(
                     
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                ScreenHelper.isMobile(context) ? 1 : 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio:
                                3 / 2, 
                          ),
                          itemCount: ScreenHelper.isMobile(context) ? 1 : 3,
                          itemBuilder: (context, index) {
                                double scale = index == 1 ? 1.0 : 0.8; 
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
            enlargeCenterPage: true, 
            autoPlayInterval: Duration(seconds: 10), 
            autoPlayAnimationDuration: Duration(seconds: 2), 
            autoPlayCurve: Curves.fastOutSlowIn, 
            height: MediaQuery.of(context).size.height / 2.1,
            viewportFraction: ScreenHelper.isMobile(context) ? 1.0 : 0.3,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
           
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
