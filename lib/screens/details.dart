
import 'package:canteen/providers/cartProvider.dart';
import 'package:canteen/providers/firebase%20functions.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canteen/util/const.dart';

import 'package:canteen/widgets/badge.dart';
import 'package:canteen/widgets/smooth_star_rating.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/menus.dart';
import '../../models/review.dart';
import '../widgets/review_dialog.dart';
class ProductDetails extends StatefulWidget {
  final Menus model;

  ProductDetails({super.key, required this.model});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final firebaseFunctions =
        Provider.of<FirebaseFunctions>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final app = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    // Define breakpoints
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(app.menuDetails),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              data: 111,
              icon: Icons.notifications,
              size: 22.0,
            ),
            onPressed: () {
              Navigator.pushNamed(context, Routes.notifications);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40.0 : 10.0,
            vertical: 10.0,
          ),
          child: ListView(
            children: <Widget>[
              // Responsive Image and Like Button Section
             MenuItemCard(
                model: widget.model, // Pass the menu item model
                onQuantityChanged: (quantity) {
                  // Handle quantity change (e.g., update cart)
                  print("Selected Quantity: $quantity");
                },
                onLikePressed: () {
                  // Handle like button pressed
                  firebaseFunctions.likePost(
                    postId: widget.model.menuID,
                    likes: widget.model.likes,
                    likesCount: widget.model.likesCount,
                  );
                },
                onReviewPressed: () {
                  // Open the review dialog
                  showDialog(
                    context: context,
                    builder: (context) => ReviewDialog(
                      menuID: widget.model.menuID,
                      menu: widget.model,
                    ),
                  );
                },
              ),

              SizedBox(height: 20.0),

              // Description Section
              Text(
                app.productDescription,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
              ),
              SizedBox(height: 10.0),
              Text(
                widget.model.menuInfo,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 20.0),

              // Reviews Section
              Text(
                app.reviews,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
              ),
              SizedBox(height: 20.0),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("menus")
                    .doc(widget.model.menuID)
                    .collection("reviews")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document =
                            snapshot.data!.docs[index];
                        Review review = Review.fromJson(
                            json: document.data() as Map<String, dynamic>);
                        return ListTile(
                          leading: CircleAvatar(
                            radius: isMobile ? 25.0 : 30.0,
                            backgroundImage: NetworkImage(review.raterImage),
                          ),
                          title: Text(review.senderName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SmoothStarRating(
                                    starCount: 5,
                                    color: Constants.ratingBG,
                                    allowHalfRating: true,
                                    rating: review.rating,
                                    size: isMobile ? 17.0 : 20.0,
                                  ),
                                  SizedBox(width: 6.0),
                                  Text(
                                    DateFormat('dd/MM/yyyy ')
                                        .format(review.reviewDate),
                                    style: TextStyle(
                                      fontSize: isMobile ? 15 : 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 7.0),
                              Text(
                                review.description,
                                style: TextStyle(
                                  fontSize: isMobile ? 15 : 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 82,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              child: Text(app.addToCart, ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white
              ),
              onPressed: () {

            
                int quantity = cartProvider.getQuantity(widget.model.menuID);

                firebaseFunctions.addProductToCart(
                  menu: widget.model,
                  app: app,
                  quantity: quantity, // Send the updated quantity
                );
              //  firebaseFunctions.addProductToCart(menu: widget.model, app: app);
              },
            ),
         
          ],
        ),
      ),
    );
  }
}
