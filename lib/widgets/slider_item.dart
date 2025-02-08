import 'package:canteen/providers/firebase%20functions.dart';
import 'package:canteen/util/arguments.dart';
import 'package:canteen/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/widgets/smooth_star_rating.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/menus.dart';

class SliderItem extends StatelessWidget {

  final Menus model;

  SliderItem({
    Key? key,
  
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseFunctions =
        Provider.of<FirebaseFunctions>(context, listen: false);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, Routes.productDetails,  arguments: ProductDetailsArguments(
            model: model,
        
          ),
        );

      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
        
              return Stack(
                children: [
                  SizedBox(
               
                    //width: constraints.maxWidth.clamp(0.0, 400.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: AspectRatio(
                        aspectRatio: 3 / 2,
                        child: Image.network(
                        
                          model.thumbnailUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // Image loaded
                            } else {
                              return AspectRatio(
                                aspectRatio: 3 / 2, // A
                                child: Container(
                                  color: Colors
                                      .grey[200], // Placeholder background color
                                  child: Center(
                                    child: Icon(
                                      Icons.image, // Placeholder icon
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return AspectRatio(
                              aspectRatio: 3 / 2, // A
                              child: Container(
                                color:
                                    Colors.grey[200], // Background color for errors
                                child: Center(
                                  child: Icon(
                                    Icons
                                        .broken_image, // Icon for failed image load
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    ),
                  ),
                  Positioned(
                    right: 8.0, // Adjust to align with the image
                    bottom: 8.0, // Adjust to align with the image
                    child: RawMaterialButton(
                      onPressed: () {
                            firebaseFunctions.likePost(
                            postId: model.menuID,
                            likes: model.likes,
                            likesCount: model.likesCount);
                      },
                      fillColor: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                                                 model.likes.contains(uid)
                              ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
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
                if (model.rating != 0 || model.raters.isNotEmpty)
                  Text(
                    "${model.rating % 1 == 0 ? model.rating.toStringAsFixed(0) : model.rating.toString()} (${model.raters.length.toString()} )",
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF424242)),
                    children: [
                  const TextSpan(
                    text: r"₦",
                  ),
                  TextSpan(
                    text: model.menuPrice.toString(),
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ])),
          ),
        ],
      ),
    );
  }
}
