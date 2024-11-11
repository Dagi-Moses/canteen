import 'package:canteen/screens/HomeLayout.dart';

import 'package:canteen/screens/categories_screen.dart';
import 'package:canteen/screens/checkout.dart';
import 'package:canteen/screens/details.dart';
import 'package:canteen/screens/dishes.dart';
import 'package:canteen/screens/forgot_password.dart';

import 'package:canteen/screens/join.dart';
import 'package:canteen/screens/language%20screen.dart';

import 'package:canteen/screens/main_screen.dart';
import 'package:canteen/screens/pin_code.dart';

import 'package:canteen/screens/splash.dart';
import 'package:canteen/screens/walkthrough.dart';
import 'package:canteen/util/arguments.dart';
import 'package:flutter/material.dart';

class Routes {
  static const splash = '/splash';
  static const mainScreen = '/';
  static const homeLayout = '/home-layout';
  static const language = '/language';
  static const walkThrough = '/walk-through';
  static const categories = '/categories';
  static const checkOut = '/checkout';
  static const productDetails = '/product-details';
  static const dishes = '/dishes';
  static const join = '/auth';
  static const forgotPassword = '/forgot-password';
 static const pinCodeVerification = '/pin-code-verification';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
       case mainScreen:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case homeLayout:
        final uid = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => HomeLayout(uid: uid));
      case language:
        return MaterialPageRoute(builder: (_) => LanguageScreen());
      case walkThrough:
        return MaterialPageRoute(builder: (_) => Walkthrough());
    
      case categories:
        final args = settings.arguments as CategoriesScreenArguments;
        return MaterialPageRoute(
            builder: (_) => CategoriesScreen(catie: args.catie, len: args.len));
      case checkOut:
        return MaterialPageRoute(builder: (_) => Checkout());
      case productDetails:
        final args = settings.arguments as ProductDetailsArguments;
        return MaterialPageRoute(
            builder: (_) =>
                ProductDetails(model: args.model, isFav: args.isFav));
      case dishes:
        return MaterialPageRoute(builder: (_) => DishesScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());

        case pinCodeVerification:
        final phoneNumber = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) =>
              PinCodeVerificationScreen(phoneNumber: phoneNumber ?? ''),
        );

    
   case join:
        final canPop =
            settings.arguments is bool ? settings.arguments as bool : false;

        return MaterialPageRoute(builder: (_) => JoinApp(canPop: canPop,));

      default:
        return MaterialPageRoute(builder: (_) => JoinApp());
    }
  }
}
