//import 'package:canteen/admin/config/theme.dart';
import 'package:canteen/screens/join.dart';
import 'package:canteen/screens/splash.dart';
import 'package:canteen/util/const.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:firebase_core/firebase_core.dart';



import 'firebase_options.dart';
import 'providers/app_provider.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        // Add your additional providers here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Consumer<AppProvider>(
        builder: (BuildContext context, AppProvider appProvider, Widget? child) {
          return MaterialApp(
           key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          darkTheme: Constants.darkTheme,
          home: SplashScreen(),
          );
        },
      
    );
  }
}
