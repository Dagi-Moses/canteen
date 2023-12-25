import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../../providers/provider.dart';

class SellerInfo extends StatefulWidget {
  const SellerInfo({Key? key}) : super(key: key);

  @override
  State<SellerInfo> createState() => _SellerInfoState();
}

class _SellerInfoState extends State<SellerInfo> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(
        seconds: 1,
      ),
      () {
        Provider.of<UserProvider>(context, listen: false)
            .retrieveSellerEarnings();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/restaurant.png",
                          height: 30,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          userProvider.name,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      userProvider.email,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "Earnings: ",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Text(
                              r"₦",
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Text(
                              userProvider.sellerTotalEarnings.toString(),
                              // +"\$"
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Material(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(80),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                        backgroundColor: userProvider.profileImage == ''
                            ? Colors.yellow
                            : Colors.black,
                        backgroundImage: userProvider.profileImage != ''
                            ? NetworkImage(userProvider.profileImage!)
                            : null,
                        child: userProvider.profileImage == ''
                            ? Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.black,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 2,
            color: Colors.white,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/menu.png",
                height: 30,
              ),
              Text(
                "Menus",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
