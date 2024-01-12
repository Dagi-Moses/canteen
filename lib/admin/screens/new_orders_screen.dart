import 'package:canteen/admin/widgets/orders.dart';
import 'package:canteen/models/order%20request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/order_card_design.dart';

import '../widgets/simple_app_bar.dart';

class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({Key? key}) : super(key: key);

  @override
  _NewOrdersScreenState createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "New Orders",
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset(-2.0, 0.0),
            end: FractionalOffset(5.0, -1.0),
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFAC898),
            ],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .orderBy("orderDate", descending: true)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];

                      OrderRequestModel model =
                          OrderRequestModel.getModelFromJson(
                              json: document.data() as Map<String, dynamic>);
                      return snapshot.hasData
                          ? OrdersWidget( context: context, model: model,)
                          : Center(
                              child: //circularProgress()
                                  Text('No data Available'));
                    })
                : Center(
                    // child: circularProgress(),
                    child: Text('No data'),
                  );
          },
        ),
      ),
    );
  }
}
