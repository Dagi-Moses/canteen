import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:canteen/admin/models/menus.dart';
import 'package:canteen/admin/widgets/my_drawer.dart';
import 'package:canteen/admin/widgets/progress_bar.dart';
import 'package:canteen/admin/widgets/seller_info.dart';
import '../upload_screens/menus_upload_screen.dart';
import '../widgets/info_design.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Container(
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
        child: CustomScrollView(
          slivers: [
            //appbar
            SliverAppBar(
              elevation: 1,
              pinned: true,
              backgroundColor: const Color(0xFFFAC898),
              foregroundColor: Colors.black,
              expandedHeight: 50,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset(-1.0, 0.0),
                    end: FractionalOffset(4.0, -1.0),
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFFAC898),
                    ],
                  ),
                ),
                child: FlexibleSpaceBar(
                  title: Text(
                    'Admin View',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  centerTitle: false,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      ),
                      child: const Icon(Icons.add),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const MenusUploadScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // this is where seller info is displayed
            const SliverToBoxAdapter(
              child: SellerInfo(),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sellers")
                  //.doc(sharedPreferences!.getString("uid"))
                  .doc(uid)
                  .collection("menus")
                  //ordering menus and items by publishing date (descending)
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: circularProgress(),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  // Handle the case when the data is still loading
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  // Handle any errors in fetching data
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  // Handle the case when there is no data to display
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text("No data available"),
                    ),
                  );
                } else {
                  // Data is available, so build the grid
                  return SliverStaggeredGrid.countBuilder(
                    staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                    crossAxisCount: 1,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    itemBuilder: (context, index) {
                      Menus model = Menus.fromJson(snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InfoDesignWidget(
                          model: model,
                          context: context,
                        ),
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
