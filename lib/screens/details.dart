import 'package:canteen/providers/cartProvider.dart';
import 'package:canteen/providers/firebase%20functions.dart';
import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/widgets/buttons/cartButton.dart';
import 'package:canteen/widgets/menuWidgets/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:canteen/util/const.dart';

import 'package:canteen/widgets/badge.dart';
import 'package:canteen/widgets/smooth_star_rating.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
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
 AppLocalizations? app;
   Menus ?menu;
  MenuProvider? menuProvider;
 CartProvider? cartProvider;

 

 
  

  @override
  Widget build(BuildContext context) {
    app = AppLocalizations.of(context)!;
    menuProvider = Provider.of<MenuProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context);
   

    menu = menuProvider!.menus.firstWhere(
      (m) => m.menuID == widget.model.menuID,
      orElse: () => widget.model,
    );

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(app!.menuDetails),
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
                horizontal: ScreenHelper.isDesktop(context) ? 40.0 : 20.0,
                vertical: 10.0,
              ),
              child: ScreenHelper(
                desktop: _buildTabletView(),
                mobile: _buildMobileView(),
                tablet: _buildTabletView(),
              )),
        ),
        bottomNavigationBar:
           ScreenHelper.isMobile(context)  ? _buildButton() : null);
  }

  Widget _buildMobileView() {
    return ListView(
      children: <Widget>[
        _buildMenu(),
        SizedBox(height: 20.0),
        _buildDescription(),
        SizedBox(height: 20.0),
        _buildReviews(CrossAxisAlignment.start),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildButton() {
    return CustomElevatedButton(
      text: app!.addToCart,
      isLoading: cartProvider!.isLoading,
      onPressed: () {
      
        cartProvider!.addProductToCart(
          menu: menu!,
          app: app!,
      
        );
      },
    );
  }

  Widget _buildTabletView() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: ListView(
      children: <Widget>[
              
                _buildReviews(CrossAxisAlignment.center),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        Container(
          width: 1.5, // Thickness of the divider
          color: Colors.grey[300], // Light grey color for subtle effect
          margin: EdgeInsets.symmetric(
              vertical: 10), // Add spacing from top & bottom
        ),
        Expanded(
          child: Column(
          
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Pushes button to bottom
            children: [
              SingleChildScrollView(
                child: Column(
                  // Wrap top content in another Column
                  children: [
                    ResponsiveWrapper(maxWidth: 400, child: _buildMenu()),
                    SizedBox(height: 20.0),
                    _buildDescription(),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: _buildButton(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenu() {
    return SizedBox(
      width: 800,
      child: MenuItemCard(
        menuID: menu!.menuID,
        onQuantityChanged: (quantity) {
          print("Selected Quantity: $quantity");
        },
        onLikePressed: () {
          menuProvider!.likePost(
            menuId: menu!.menuID,
            likes: menu!.likes,
          );
        },
        onReviewPressed: () {

          showDialog(
            context: context,
            builder: (context) => ReviewDialog(
              menu: menu!,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescription( ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          app!.productDescription,
          style: TextStyle(
            fontSize: ScreenHelper.isMobile(context)  ? 18 : 22,
            fontWeight: FontWeight.w800,
          ),
          maxLines: 2,
        ),
        SizedBox(height: 10.0),
        Text(
          menu!.menuInfo,
          style: TextStyle(
            fontSize: ScreenHelper.isMobile(context) ? 16 : 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildReviews(CrossAxisAlignment axis) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("menus")
          .doc(widget.model.menuID)
          .collection("reviews")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return Column(
              crossAxisAlignment: axis,
            children: [
              Text(
                app!.reviews,
                style: TextStyle(
                  fontSize: ScreenHelper.isMobile(context) ? 18 : 22,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
              ),
              SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: AlwaysScrollableScrollPhysics(),
                // physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Review review = Review.fromJson(
                      json: document.data() as Map<String, dynamic>);
                  return  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ListTile(
              
                      leading: CircleAvatar(
                        radius: ScreenHelper.isMobile(context) ? 25.0 : 30.0,
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
                                size: ScreenHelper.isMobile(context) ? 17.0 : 20.0,
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                DateFormat('dd/MM/yyyy ').format(review.reviewDate),
                                style: TextStyle(
                                  fontSize:
                                      ScreenHelper.isMobile(context) ? 15 : 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7.0),
                          Text(
                            review.description,
                            style: TextStyle(
                              fontSize: ScreenHelper.isMobile(context) ? 15 : 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ;
                },
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
