import 'package:canteen/providers/cartProvider.dart';
import 'package:canteen/util/routes.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/menus.dart';
import 'package:canteen/widgets/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: cartProvider.cartMenus.isEmpty
            ? Center(child: Text(app.noCartItems))
            : GridView.builder(
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ScreenHelper.isMobile(context) ? 1 : 3,
                  childAspectRatio: ScreenHelper.isMobile(context) ? 2.2 : 2.2,
                ),
                itemCount: cartProvider.cartMenus.length,
                itemBuilder: (BuildContext context, int index) {
                  Menus menu = cartProvider.cartMenus[index];
                  return CartItem(menu: menu);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        tooltip: app.checkOut,
        onPressed: () {
          if (!cartProvider.cartMenus.isEmpty) {
            Navigator.pushNamed(context, Routes.checkOut);
          } else {
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: app.noCartItems,
            );
          }
        },
        child: const Icon(
          Icons.arrow_forward,
        ),
        heroTag: Object(),
      ),
    );
  }
}
