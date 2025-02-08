import 'package:canteen/models/menus.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/widgets/expandableTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/searchHistoryManager.dart';
import '../widgets/HistoryWidget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchManager _history = SearchManager();
  final TextEditingController _searchControl = TextEditingController();
  List<Menus> searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchControl.addListener(() {
      _updateSearchResults(_searchControl.text);
    });
  }
void _updateSearchResults(String searchText) async {
    if (searchText.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('menus')
          .where(
            'title',
            isGreaterThanOrEqualTo: searchText.toLowerCase(),
          )
          .where(
            'title',
            isLessThan: searchText.toLowerCase() + '\uf8ff',
          )
          .get();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          searchResults = snapshot.docs
              .map((doc) =>
                  Menus.fromJson(json: doc.data() as Map<String, dynamic>))
              .where((menu) =>
                  menu.menuTitle.toLowerCase().contains(searchText.toLowerCase()))
              .toList();
        });
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          searchResults.clear();
        });
      });
    }
  }


  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          
          title: ExpandableTextField(
            focusNode: focusNode,
            controller: _searchControl,
            hintText: app.search,
          ),
          
           
          expandedHeight: 70.0,
          floating: false,
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
              children: <Widget>[
              
                _searchControl.text.isEmpty
                    ? _buildSearchHistory(app)
                   :buildGridView(),
                 
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget buildGridView( ) {
    return GridView.builder(
    shrinkWrap: true,
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ScreenHelper.isDesktop(context)
            ? 5
            : ScreenHelper.isTablet(context)
                ? 4
                : 1,
        childAspectRatio:ScreenHelper.isMobile(context)? 1.0: 0.9,
      ),
   
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return HistoryWidget(
          focusNode: focusNode,
          menu: searchResults[index],
        );
      },
    );
  }


  Widget _buildSearchHistory(AppLocalizations app) {
    return FutureBuilder(
      future: _history.getMenusFromSharedPreferences(),
      builder: (BuildContext context, AsyncSnapshot<List<Menus>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('${app.error}: ${snapshot.error}');
        } else {
          List<Menus> historyData = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: historyData.length,
            itemBuilder: (BuildContext context, int index) {
              final document = historyData[index];

              return Dismissible(
                key: Key(index.toString()),
                direction: DismissDirection.horizontal,
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: AlignmentDirectional.centerEnd,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _history.deleteMenuFromSharedPreferences(document.menuTitle);
                },
                child: HistoryWidget(
                  focusNode: focusNode,
                  menu: document,
                ),
              );
            },
          );
        }
      },
    );
  }
}
