import 'package:canteen/providers/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const kDefaultPaddin = 20.0;

class CartCounter extends StatelessWidget {
  final String menuID;
  bool isCart;
  CartCounter({super.key, required this.menuID, this.isCart = false});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Padding(
      padding: EdgeInsets.only(top: 5, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 40,
            height: 32,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                elevation: 5,
                side: const BorderSide(
                  color: Colors.black,
                ), // Correctly applies red border

                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(3), // Sharp edges (0 radius)
                ),
              ),
              onPressed: () {
                if (isCart) {
                  cartProvider.removeCartQuantity(menuID);
                } else {
                  cartProvider.removeQuantity(menuID);
                }
              },
              child: const Icon(
                Icons.remove,
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
            child: Text(
              isCart?cartProvider.getCartQuantity(menuID).toString() :
              cartProvider.getQuantity(menuID).toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            width: 40,
            height: 32,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                elevation: 5,
                side: const BorderSide(
                  color: Colors.black,
                ),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(3), // Sharp edges (0 radius)
                ),
              ),
              onPressed: () {
                if (isCart) {
                  cartProvider.addCartQuantity(menuID);
                } else {
                  cartProvider.addQuantity(menuID);
                }
              },
              child: const Icon(
                Icons.add,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
