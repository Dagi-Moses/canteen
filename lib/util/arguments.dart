import 'package:canteen/models/menus.dart';

class CategoriesScreenArguments {
  final String catie;
  final int len;

  CategoriesScreenArguments({required this.catie, required this.len});
}

class ProductDetailsArguments {
  final Menus model;
  final bool isFav;

  ProductDetailsArguments({required this.model, required this.isFav});
}
