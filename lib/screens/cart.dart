import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:canteen/screens/checkout.dart';

import 'package:canteen/widgets/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/menus.dart';
import '../providers/app_provider.dart';
import '../util/const.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
     {
  @override
  Widget build(BuildContext context) {
   final app = AppLocalizations.of(context)!;
    final cartMenu = Provider.of<MenuProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Provider.of<AppProvider>(context).theme == Constants.lightTheme
                ? Colors.white
                : Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 1,
              backgroundColor: Colors.red),
          child: Text(
              ' ${app.proceed + cartMenu.cartMenus.length.toString()} ${cartMenu.cartMenus.length == 1 ? app.item : app.items}'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const Checkout();
            }));
          },
        ),
        elevation: 0.0,
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(firebaseAuth.currentUser!.uid)
                  .collection("cart")
                  .orderBy('publishDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasData){

              
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    cartMenu.updateCartMenusFromSnapshot(snapshot.data!);
                   
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Menus menu = Menus.fromJson(
                        json: document.data() as Map<String, dynamic>);
                    return CartItem(
                      menu: menu,
                    );
                  },
                );  }else if(!snapshot.hasData){
                  return Center(child: Text(app.noCartItems),);

                }else{
                  return CircularProgressIndicator.adaptive();
                }
              })),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        tooltip: app.checkOut,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const Checkout();
              },
            ),
          );
        },
        child: const Icon(
          Icons.arrow_forward,
        ),
        heroTag: Object(),
      ),
    );
  }


}
