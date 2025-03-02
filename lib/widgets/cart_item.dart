import 'package:canteen/providers/cartProvider.dart';
import 'package:canteen/util/arguments.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/widgets/cartCounter.dart';
import 'package:flutter/material.dart';
import 'package:canteen/util/const.dart';
import 'package:canteen/widgets/smooth_star_rating.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../models/menus.dart';
import '../providers/firebase functions.dart';

class CartItem extends StatefulWidget {
  Menus menu;

  CartItem({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    final cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    final app = AppLocalizations.of(context)!;
    return Dismissible(
      confirmDismiss: (direction) async {
        return true;
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
       cartProvider.deleteProductFromCart(menuId: widget.menu.menuID);
      },
      key: Key(widget.menu.menuID),
      background: Container(
       // width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: Colors.white),
              Text(app.swipeToDelete, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.productDetails,
                arguments: ProductDetailsArguments(
                  model: widget.menu
                ),
              );
            },
            child: Card(
              elevation: 6.0,
             // shadowColor: ,
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: AspectRatio(
                aspectRatio: 3/ 1.2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // Shadow color
                        offset: Offset(5.0, 5.0), // Changes position of shadow
                        blurRadius: 5.0, // Changes size of shadow
                      ),
                    ],
                    color: Color.fromRGBO(240, 240, 240, 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 0.0, right: 10.0),
                        child: SizedBox(
                         // height: MediaQuery.of(context).size.width / 3.5,
                         // width: MediaQuery.of(context).size.width / 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: AspectRatio(
                              aspectRatio: 4/3,
                              child: Image.network(
                                widget.menu.thumbnailUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      //  mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.menu.menuTitle,
                            style: const TextStyle(
                              //                    fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                      
                          Row(
                            children: <Widget>[
                              SmoothStarRating(
                                borderColor: Colors.yellow,
                                starCount: widget.menu.rating,
                                color: Constants.ratingBG,
                                allowHalfRating: true,
                                rating: 5,
                                size: 12.0,
                              ),
                              const SizedBox(width: 6.0),
                              widget.menu.rating == 0 &&
                                      widget.menu.raters.length == 0
                                  ? SizedBox()
                                  : Text(
                                      "${widget.menu.rating % 1 == 0 ? widget.menu.rating.toStringAsFixed(0) : widget.menu.rating.toString()} (${widget.menu.raters.length.toString()} )",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    )
                            ],
                          ),
                   
                          RichText(
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
                              text: (widget.menu.menuPrice *
                                          widget.menu.quantity)
                                      .toString(),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.red,
                              ),
                            ),
                          ])),
                     
                          CartCounter(menuID: widget.menu.menuID, isCart:  true,)
                          // RichText(
                          //     text: TextSpan(children: [
                          //     TextSpan(
                          //     text: app.quantity,
                          //     style: TextStyle(
                          //       fontSize: 12.0,
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.grey[800],
                          //     ),
                          //   ),
                          //   TextSpan(
                          //     text: widget.menu.quantity.toString(),
                          //     style: TextStyle(
                          //       fontSize: 12.0,
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ])),
                         
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

_buildGradient() {
  return LinearGradient(
    colors: [Colors.red.withOpacity(0.5), Colors.black.withOpacity(0.5)],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
}
