import 'package:canteen/models/menus.dart';
import 'package:canteen/models/user.dart';

class CategoriesScreenArguments {
  final String catie;
  final int len;

  CategoriesScreenArguments({required this.catie, required this.len});
}

class ProductDetailsArguments {
  final Menus model;
 

  ProductDetailsArguments({required this.model, });
}

class RegistrationCodeVerificationArgs {
  final UserModel user;
  final String password;

  RegistrationCodeVerificationArgs(
      {required this.user, required this.password});
}

