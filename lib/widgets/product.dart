import 'package:canteen/models/menus.dart';
import 'package:canteen/widgets/cartCounter.dart';
import 'package:canteen/widgets/smooth_star_rating.dart';
import 'package:flutter/material.dart';


class MenuItemCard extends StatelessWidget {
  final Menus model;
  final Function(int) onQuantityChanged; // Callback for cart updates
  final Function() onLikePressed;
  final Function() onReviewPressed;

  const MenuItemCard({
    Key? key,
    required this.model,
    required this.onQuantityChanged,
    required this.onLikePressed,
    required this.onReviewPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),

        // Image & Like Button Section
        AspectRatio(
          aspectRatio: isMobile ? 3 / 2 : 16 / 9,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  model.thumbnailUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: -10.0,
                bottom: 3.0,
                child: RawMaterialButton(
                  onPressed: onLikePressed,
                  fillColor: Colors.white,
                  shape: CircleBorder(),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      model.likes.contains('user_id')
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),

        // Menu Title
        Text(
          model.menuTitle,
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w800,
          ),
          maxLines: 2,
        ),
        SizedBox(height: 5.0),

        // Rating Section
        GestureDetector(
          onTap: onReviewPressed,
          child: Row(
            children: [
              SmoothStarRating(
                borderColor: Colors.orange,
                starCount: 5,
                color: Colors.orange,
                allowHalfRating: true,
                rating: model.rating,
                size: isMobile ? 25.0 : 30.0,
              ),
              SizedBox(width: 10.0),
              Text(
                " ${model.rating.toString()} (${model.raters.length} Reviews)",
                style: TextStyle(
                  fontSize: isMobile ? 15.0 : 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.0),

        // Price Display
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: r"₦",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                ),
              ),
              TextSpan(
                text: model.menuPrice.toString(),
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),

 
            CartCounter(menuID: model.menuID),
          
        
      ],
    );
  }
}
