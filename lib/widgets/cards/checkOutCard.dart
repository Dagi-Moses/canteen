import 'package:canteen/providers/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutCard extends StatelessWidget {
  final TextEditingController deliveryNote;
  final AppLocalizations app;
  final CartProvider cartProvider;


  const CheckoutCard({
    Key? key,
    required this.deliveryNote,
    required this.app,
    required this.cartProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    hintText: app.deliveryNote,
                    prefixIcon: Icon(
                      Icons.note,
                      color: Colors.red,
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  maxLines: 1,
                  controller: deliveryNote,
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
                          text: cartProvider.totalCartPrice.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.red,
                          ),
                        ),
                      ])),
                      Text(
                        app.deliveryCharges,
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
                    onPressed: () async {
                      cartProvider.checkOut(
                          app: app,
                          context: context,
                          deliveryNote: deliveryNote.text);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
