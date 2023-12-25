import 'package:canteen/models/menus.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:canteen/widgets/cart_item.dart';
import 'package:provider/provider.dart';

import '../admin/screens/paymentPage.dart';
import '../providers/provider.dart';

class Checkout extends StatefulWidget {
  const Checkout({
    super.key,
  });
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final TextEditingController _couponlControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartMenu = Provider.of<MenuProvider>(
      context,
    );
    final app = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          app.checkOut,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            tooltip: app.back,
            icon: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 130),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    app.shippingAddress,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: Text(
                  userProvider.name,
                  style: const TextStyle(
        //                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text(userProvider.address),
              ),
              const SizedBox(height: 10.0),
             Text(
                app.paymentMethod,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Card(
                color: Colors.white,
          shadowColor: Colors.grey[900],
          surfaceTintColor: Colors.white,
                elevation: 4.0,
                child: ListTile(
                  title: Text(userProvider.name),
                  subtitle:  Text(
                    app.payStack,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  leading: Icon(
                    FontAwesomeIcons.creditCard,
                    size: 50.0,
                    color: Colors.red,
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
               Text(
                app.items,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: cartMenu.cartMenus.length,
                itemBuilder: (BuildContext context, int index) {
                  final food = cartMenu.cartMenus[index];
        
                  return CartItem(
                    menu: food,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding:EdgeInsets.only( bottom:MediaQuery.of(context).padding.bottom),
        child: Card(
          color: Colors.white,
          shadowColor: Colors.grey[900],
          surfaceTintColor: Colors.white,
          elevation: 4.0,
          child: SizedBox(
            height: 130,
            child: ListView(
           
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.grey[200]!,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[200]!,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: app.couponCode,
                        prefixIcon: Icon(
                          Icons.redeem,
                          color: Colors.red,
                        ),
                        hintStyle: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                      maxLines: 1,
                      controller: _couponlControl,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           Text(
                            app.total,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
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
                              text: cartMenu.totalCartPrice.toString(),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.red,
                              ),
                            ),
                          ])),
                           Text(
                           app.deliveryCharges ,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                      width: 150.0,
                      height: 50.0,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          app.placeOrder.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_){
                            return PaymentPage();
                          }));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
