import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {


  // int _currentPage = 0;
  PageController _pageController = PageController();

  int get currentPage =>
      _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;
  PageController get pageController => _pageController;
  

  void changePage(int index) {
   // _currentPage = index;
   _pageController.jumpToPage(index);
    notifyListeners(); // Notifies UI to rebuild
  }


  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the PageController
    super.dispose();
  }
}
