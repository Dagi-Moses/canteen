import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:canteen/admin/widgets/simple_app_bar.dart';
import 'package:intl/intl.dart';

import '../../models/menus.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Menus? model;
  const ItemDetailsScreen({Key? key, this.model}) : super(key: key);

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID) {
    FirebaseStorage.instance
        .ref()
        .child("menus")
        .child(widget.model!.menuID + ".jpg")
        .delete();
    FirebaseFirestore.instance
        .collection("menus")
        .doc(widget.model!.menuID)
        .delete()
        .then(
      (value) {
        Fluttertoast.showToast(msg: "Item Deleted");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Item Detail',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                color: Colors.white,
                height: 250,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                              gradient: LinearGradient(
                                begin: FractionalOffset(1.0, 1.0),
                                end: FractionalOffset(1.0, 1.0),
                                colors: [
                                  Color(0xFFFFFFFF),
                                  Color(0xFFFAC898),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(-1, 10),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.network(
                            widget.model!.thumbnailUrl.toString(),
                            height: 300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color(0xFFFAC898),
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.model!.menuTitle.toString(),
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category: ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.model!.category.toString(),
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description: ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.model!.menuInfo.toString(),
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date Uploaded: ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm:ss')
                                .format(widget.model!.publishDate),
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Price: ",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "\$" + widget.model!.menuPrice.toString(),
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[900],
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              onPressed: () {
                                deleteItem(widget.model!.menuID);
                              },
                              child: Row(children: [
                                Text(
                                  'Delete',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
