import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:canteen/screens/details.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/widgets/smooth_star_rating.dart';

import '../../models/menus.dart';

class GridProduct extends StatelessWidget {

  final Menus model;
 


  GridProduct({
    Key? key,
    required this.model,
   })
      :super(key: key);

  @override
  Widget build(BuildContext context) {
     String uid = FirebaseAuth.instance.currentUser!.uid;
    return InkWell(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.6,
                width: MediaQuery.of(context).size.width / 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    model.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned(
                right: -10.0,
                bottom: 3.0,
                child: RawMaterialButton(
                  onPressed: (){},
                  fillColor: Colors.white,
                  shape: CircleBorder(),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      model.likes.contains(uid)
                          ?Icons.favorite
                          :Icons.favorite_border,
                      color: Colors.red,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ],


          ),

          Padding(
            padding: EdgeInsets.only(bottom: 2.0, top: 8.0),
            child: Text(
              model.menuTitle,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 2,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SmoothStarRating(
                  borderColor: Colors.yellow,

                  starCount: 5,
                  color: Constants.ratingBG,
                  allowHalfRating: true,
                  rating: model.rating,
                  size: 15.0,
                ),

                model.rating ==0 && model.raters.length == 0? SizedBox():
                Text(
                  "${model.rating % 1 == 0 ? model.rating.toStringAsFixed(0) : model.rating.toString()} (${model.raters.length.toString()} )",
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                )

              ],
            ),
          ),


        ],
      ),
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context){
              return ProductDetails(model: model,isFav: model.likes.contains(uid),);
            },
          ),
        );
      },
    );
  }
}
