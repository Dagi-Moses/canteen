import 'package:canteen/util/firebase%20functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:canteen/screens/notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canteen/util/const.dart';

import 'package:canteen/widgets/badge.dart';
import 'package:canteen/widgets/smooth_star_rating.dart';
import 'package:intl/intl.dart';
import '../../models/menus.dart';
import '../../models/review.dart';
import '../widgets/review_dialog.dart';

class ProductDetails extends StatefulWidget {
  final Menus model;
  final bool isFav;

  ProductDetails({super.key, required this.model, required this.isFav});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
      final prov = MenuProvider();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom ),
      child: Scaffold(
        
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            app.menuDetails,
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: IconBadge(
                icon: Icons.notifications,
                size: 22.0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Notifications();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
             padding: EdgeInsets.only(
              left:10,
              right :10,
              ),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 10.0),
                Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 3.2,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          widget.model.thumbnailUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -10.0,
                      bottom: 3.0,
                      child: RawMaterialButton(
                        onPressed: () {
                          likePost(
                              postId: widget.model.menuID,
                              likes: widget.model.likes,
                              likesCount: widget.model.likesCount);
                        },
                        fillColor: Colors.white,
                        shape: CircleBorder(),
                        elevation: 4.0,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            widget.isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  widget.model.menuTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                  child: Row(
                    children: <Widget>[
                      SmoothStarRating(
                        borderColor: Constants.ratingBG,
                        starCount: 5,
                        color: Constants.ratingBG,
                        allowHalfRating: true,
                        rating: widget.model.rating,
                        size: 25.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        " ${widget.model.rating.toString()} (${widget.model.raters.length.toString()} Reviews)",
                        style:
                            TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                  child: RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                      text: r"₦",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: widget.model.menuPrice.toString(),
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.red,
                      ),
                    ),
                  ])),
                ),
                SizedBox(height: 20.0),
                Text(
                  app.productDescription,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 10.0),
                Text(
                  widget.model.menuInfo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  app.reviews,
                  style: TextStyle(
                    fontSize: 18,
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
                          DocumentSnapshot document = snapshot.data!.docs[index];
                          Review review = Review.fromJson(
                              json: document.data() as Map<String, dynamic>);
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 25.0,
                              backgroundImage: NetworkImage(
                                review.raterImage,
                              ),
                            ),
                            title: Text(review.senderName),
                            subtitle: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SmoothStarRating(
                                      starCount: 5,
                                      color: Constants.ratingBG,
                                      allowHalfRating: true,
                                      rating: review.rating,
                                      size: 17.0,
                                    ),
                                    SizedBox(width: 6.0),
                                    Text(
                                      // DateFormat.jm('MM/dd/yyyy').format(review.reviewDate),
                                      DateFormat('dd/MM/yyyy ')
                                          .format(review.reviewDate),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7.0),
                                Text(
                                  review.description,
                                  style: TextStyle(
                                    fontSize: 15,
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
              Container(
                height: 40.0,
                width: double.maxFinite,
                child: ElevatedButton(
                  child: Text(
                    app.leaveReview,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    elevation: 10.0,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => ReviewDialog(
                              menuID: widget.model.menuID,
                              menu: widget.model,
                            ));
                  },
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 40.0,
                child: ElevatedButton(
                  child: Text(
                    app.addToCart,
                    style: TextStyle(
                      color: Colors.grey[900],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 10.0,
                  ),
                  onPressed: () {
                    addProductToCart(menu: widget.model);
                     prov.updateCartNo(prov.cartNo +1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
