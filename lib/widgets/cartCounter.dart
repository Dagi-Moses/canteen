import 'package:canteen/providers/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


const kDefaultPaddin = 20.0;

class CartCounter extends StatelessWidget {
   final String menuID;
  const CartCounter({super.key, required this.menuID});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 40,
            height: 32,
            child: OutlinedButton(
              
              style: OutlinedButton.styleFrom(
                elevation: 5,
            side: 
        const BorderSide(color: Colors.black, ), // Correctly applies red border
         
                padding: EdgeInsets.zero,
                 shape: RoundedRectangleBorder(
                   
                  borderRadius:
                      BorderRadius.circular(3), // Sharp edges (0 radius)
                ),
              ),
              onPressed: () {
                 cartProvider.removeQuantity(menuID);
              },
              child: const Icon(Icons.remove, color: Colors.red,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
            child: Text(
              // if our item is less  then 10 then  it shows 01 02 like that
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
              cartProvider.addQuantity(menuID);
              },
              child: const Icon(Icons.add, color: Colors.red,),
            ),
          ),
        ],
      ),
    );
  }
}
