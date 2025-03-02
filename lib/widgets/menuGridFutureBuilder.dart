// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:canteen/models/menus.dart';
import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/widgets/placeHolders.dart/custom_image_placeholder.dart';
import 'package:canteen/widgets/slider_item.dart';

class MenuGridFutureBuilder extends StatelessWidget {
 final List<Menus> menus;
  final MenuProvider menuProvider;
   // Add this flag to control the logic


   MenuGridFutureBuilder({
    Key? key,
    // Default to false
    required this.menus,
    required this.menuProvider
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Center(
      child: Builder(
        builder: (_) {
          if (menuProvider.isLoading) {
       
            return  SizedBox(
           height: 
                   MediaQuery.of(context).size.height / 1.5,
                  
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ScreenHelper.isDesktop(context)
                      ? 5
                      : ScreenHelper.isTablet(context)
                          ? 4
                          : 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                 childAspectRatio: 3/2,
                ),
                itemCount: ScreenHelper.isMobile(context) ? 6 : 10,
                itemBuilder: (context, index) {
                 
                  return  CustomImagePlaceHolderWidget()  ;
                },
              ),
            );
          }else    if (menus.isEmpty) {
            return Center(child: Text('No menu available'));
          }  
      
      
      
      
          return GridView.builder(
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              
              crossAxisCount: ScreenHelper.isDesktop(context)
                  ? 5
                  : ScreenHelper.isTablet(context)
                      ? 4
                      : 2,
             childAspectRatio:0.9
      
            ),
            
            itemCount: menus.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,),
                child: SliderItem(model: menus[index], menuProvider: menuProvider,),
              );
            },
          );
        },
      ),
    );
  }
}

