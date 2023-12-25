import 'package:flutter/material.dart';
import 'package:canteen/screens/details.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/widgets/smooth_star_rating.dart';

import '../../models/menus.dart';
import '../util/firebase functions.dart';

class SliderItem extends StatelessWidget {
  final bool isFav;
  final Menus model;

  SliderItem({
    Key? key,
    required this.isFav,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.2,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: model.thumbnailUrl == ''
                      ? const CircularProgressIndicator()
                      : Image.network(
                          model.thumbnailUrl,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                right: -10.0,
                bottom: 3.0,
                child: RawMaterialButton(
                  onPressed: () {},
                  fillColor: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () {
                        likePost(
                            postId: model.menuID,
                            likes: model.likes,
                            likesCount: model.likesCount);
                      },
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0, top: 8.0),
            child: Text(
              model.menuTitle,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top: 2.0),
            child: Row(
              children: <Widget>[
                SmoothStarRating(
                  borderColor: Constants.ratingBG,
                  starCount: 5.0,
                  color: Constants.ratingBG,
                  allowHalfRating: true,
                  rating: model.rating,
                  size: 22.0,
                ),
                model.rating ==0 && model.raters.length == 0? SizedBox():
                Text(
                  "${model.rating % 1 == 0 ? model.rating.toStringAsFixed(0) : model.rating.toString()} (${model.raters.length.toString()} )",
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductDetails(
                isFav: isFav,
                model: model,
              );
            },
          ),
        );
      },
    );
  }
}
