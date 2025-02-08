import 'package:canteen/models/menus.dart';
import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/widgets/custom_image_placeholder.dart';
import 'package:canteen/widgets/slider_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MenuGridFutureBuilder extends StatefulWidget {
  final Future<List<Menus>> future;
  final bool shouldUpdateMenus; // Add this flag to control the logic


  const MenuGridFutureBuilder({
    Key? key,
    required this.future,
    this.shouldUpdateMenus = false,
  
     // Default to false
  }) : super(key: key);

  @override
  State<MenuGridFutureBuilder> createState() => _MenuGridFutureBuilderState();
}

class _MenuGridFutureBuilderState extends State<MenuGridFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Menus>>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
     
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
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading data'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No data available'),
          );
        }

        final menus = snapshot.data!;

        // Conditionally update menus only if `shouldUpdateMenus` is true
        if (widget.shouldUpdateMenus) {
          Provider.of<MenuProvider>(context, listen: false).updateMenus(menus);
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
              child: SliderItem(model: menus[index]),
            );
          },
        );
      },
    );
  }
}

