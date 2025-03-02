
import 'package:canteen/models/menus.dart';
import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/providers/search_provider.dart';
import 'package:canteen/util/screenHelper.dart';
import 'package:canteen/widgets/textFields/expandableTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../widgets/HistoryWidget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

 
  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context);
    final app = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [ExpandableTextField(
            focusNode: searchProvider.focusNode,
            controller: searchProvider.searchControl,
            hintText: app.search,
          ),],
          title:    searchProvider.searchControl.text.isEmpty? Text("Search History"): null,
          centerTitle: true,
          expandedHeight: 70.0,
          floating: false,
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
              children: <Widget>[
                searchProvider.searchControl.text.isEmpty
                    ? _buildSearchHistory(app, menuProvider, searchProvider)
                   :buildGridView(menuProvider, searchProvider),
                 
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget buildGridView(MenuProvider menuProvider, SearchProvider searchProvider ) {
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
   
      itemCount: searchProvider.searchResults.length,
      itemBuilder: (context, index) {
        return HistoryWidget(
          menuProvider: menuProvider,
          focusNode: searchProvider.focusNode,
          menu: searchProvider.searchResults[index],
        );
      },
    );
  }


  
  Widget _buildSearchHistory(AppLocalizations app, MenuProvider menuProvider,
      SearchProvider searchProvider) {
    return FutureBuilder<List<Menus>>(
      future: searchProvider.getSearchHistory(),
      builder: (BuildContext context, AsyncSnapshot<List<Menus>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('${app.error}: ${snapshot.error}');
        } else {
          List<Menus> historyData = snapshot.data!;
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
              childAspectRatio: ScreenHelper.isMobile(context) ? 1.0 : 0.9,
            ),
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
                 searchProvider.deleteHistoryItem(document.menuTitle);
                },
                child: HistoryWidget(
                  menuProvider: menuProvider,
                  focusNode:  searchProvider.focusNode,
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
