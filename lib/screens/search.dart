import 'package:canteen/models/menus.dart';
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
          .get();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          searchResults = snapshot.docs
              .map((doc) =>
                  Menus.fromJson(json: doc.data() as Map<String, dynamic>))
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
          centerTitle: true,
          title: Card(
            elevation: 6.0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                // onSubmitted: (v) {
                //   focusNode.unfocus();
                // },
                focusNode: focusNode,
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: app.search,
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                controller: _searchControl,
              ),
            ),
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
              _searchControl.text.isEmpty?  Center(child: Text("History"),) : SizedBox(),
                _searchControl.text.isEmpty
                    ? _buildSearchHistory()
                    : ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: searchResults.length,
                        itemBuilder: (BuildContext context, int index) {
                          return HistoryWidget(
                            focusNode: focusNode,
                            menu: searchResults[index],
                          );
                        },
                      ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHistory() {
    return FutureBuilder(
      future: _history.getMenusFromSharedPreferences(),
      builder: (BuildContext context, AsyncSnapshot<List<Menus>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
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
