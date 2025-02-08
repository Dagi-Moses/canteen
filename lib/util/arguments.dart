import 'package:canteen/models/menus.dart';

class CategoriesScreenArguments {
  final String catie;
  final int len;

  CategoriesScreenArguments({required this.catie, required this.len});
}

class ProductDetailsArguments {
  final Menus model;
 

  ProductDetailsArguments({required this.model, });
}
