
import 'package:canteen/screens/splash.dart';
import 'package:canteen/providers/provider.dart';
import 'package:canteen/util/const.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';


import '/models/menus.dart';
import 'firebase_options.dart';
import 'providers/app_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget? child) {
        return MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: appProvider.preferredLocale,
          supportedLocales: [
            Locale('en'),
            Locale('ig'),
            Locale('yo'),
            Locale('fr'),
          ],
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
