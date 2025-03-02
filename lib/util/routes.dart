import 'package:canteen/admin/screens/dashboard.dart';
import 'package:canteen/admin/screens/paymentPage.dart';
import 'package:canteen/auth/authStateListener.dart';
import 'package:canteen/screens/HomeLayout.dart';

import 'package:canteen/screens/categories_screen.dart';
import 'package:canteen/screens/checkout.dart';
import 'package:canteen/screens/details.dart';
import 'package:canteen/screens/dishes.dart';
import 'package:canteen/screens/forgot_password.dart';

import 'package:canteen/screens/join.dart';
import 'package:canteen/screens/language%20screen.dart';

import 'package:canteen/screens/main_screen.dart';
import 'package:canteen/screens/notifications.dart';
import 'package:canteen/screens/pin_code.dart';

import 'package:canteen/screens/splash.dart';
import 'package:canteen/screens/walkthrough.dart';
import 'package:canteen/util/arguments.dart';
import 'package:flutter/material.dart';

class Routes {
 static const authState = '/';
  static const splash = '/splash';
  static const mainScreen = '/home';
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
  static const notifications = '/notifications';
  static const paymentPage = '/payment';
  static const dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
         case authState:
        return MaterialPageRoute(
          builder: (_) => AuthStateListener(),
        );
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case mainScreen:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case homeLayout:
        return MaterialPageRoute(builder: (_) => HomeLayout());
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
                ProductDetails(model: args.model, ));
      case dishes:
        return MaterialPageRoute(builder: (_) => DishesScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashBoard());
    case forgotPassword:
        final bool? isForgotPassword = settings.arguments as bool?;
        return MaterialPageRoute(
          builder: (_) =>
              ForgotPasswordScreen(isForgotPassword: isForgotPassword ?? false),
        );
      case pinCodeVerification:
        final phoneNumber = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) =>
              PinCodeVerificationScreen(phoneNumber: phoneNumber ?? ''),
        );
      case paymentPage:
        final note = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) =>
              PaymentPage(note: note,),
        );
      case join:
        final canPop =
            settings.arguments is bool ? settings.arguments as bool : false;
        return MaterialPageRoute(
            builder: (_) => JoinApp(
                  canPop: canPop,
                ));
      case notifications:
    
        return MaterialPageRoute(
            builder: (_) => Notifications()
                );
      default:
        return MaterialPageRoute(builder: (_) => JoinApp());
    }
  }
}
