import 'package:canteen/admin/widgets/simple_dialog.dart';
import 'package:canteen/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:canteen/admin/screens/history_screen.dart';
import 'package:canteen/admin/screens/home_screen.dart';
import 'package:canteen/admin/screens/new_orders_screen.dart';

import 'package:provider/provider.dart';

import '../../providers/provider.dart';
import '../../util/const.dart';
import '../functions.dart';
import '/screens/join.dart';

class MyDrawer extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Drawer(
      child: Container(
        child: ListView(
          children: [
            //header drawer
            Container(
              padding: const EdgeInsets.only(top: 25, bottom: 10),
              child: Column(
                children: [
                  Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(80),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: SizedBox(
                        height: 160,
                        width: 160,
                        child: Container(
                          child: GestureDetector(
                            onTap: () async {
                              takeImage(context: context);
                            },
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
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userProvider.name,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            //body drawer
            Container(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                children: [
                  const Divider(
                    height: 10,
                    color: Colors.black,
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text(
                      'Home',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.white,
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.reorder,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text(
                      'New Orders',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const NewOrdersScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.white,
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.local_shipping,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text(
                      'History - Orders',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.white,
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 30,
                    ),
                    title: Text(
                      'View Users App',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => MainScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.white,
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                      size: 30,
                    ),
                    title: Text(
                      'Sign Out',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      signout(
                          context: context,
                          onTap: () {
                            firebaseAuth.signOut().then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => JoinApp(),
                                ),
                              );
                              _controller.clear();
                            });
                          });
                    },
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.white,
                    thickness: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
