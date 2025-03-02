import 'package:canteen/controllers/profileController.dart';
import 'package:canteen/providers/authProvider.dart';
import 'package:canteen/providers/cartProvider.dart';
import 'package:canteen/providers/emailProvider.dart';
import 'package:canteen/providers/location_provider.dart';
import 'package:canteen/providers/menusProvider.dart';
import 'package:canteen/providers/firebase%20functions.dart';
import 'package:canteen/providers/navigationProvider.dart';
import 'package:canteen/providers/search_provider.dart';
import 'package:canteen/util/routes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:canteen/providers/userProvider.dart';
import 'package:canteen/util/const.dart';
import 'firebase_options.dart';
import 'providers/app_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseFunctions()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => EmailProvider()),
       
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        // ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
   ChangeNotifierProxyProvider2<UserProvider, AppProvider,
          SettingsController>(
        create: (_) => SettingsController(
            userProvider: UserProvider(), prov: AppProvider()),
        update: (_, userProvider, appProvider, previous) =>
            SettingsController(userProvider: userProvider, prov: appProvider),
      ),
   ChangeNotifierProxyProvider<UserProvider, CartProvider>(
          create: (_) => CartProvider(
              userProvider: UserProvider()),
          update: (_, userProvider, previousCartProvider) =>
              CartProvider(userProvider: userProvider),
        ),

      ],
      child:    DevicePreview(
  //  enabled: !kReleaseMode,
   enabled: false,
    builder: (context) => MyApp(), // Wrap your app
  ),
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
       final app = AppLocalizations.of(context);
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget? child) {
        return MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
         
          ],
           useInheritedMediaQuery: true,
     // locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
         locale: appProvider.preferredLocale,
          supportedLocales: [
             Locale('en', ), // English
            Locale('fr', ), // French
            Locale('ig', ), // Igbo
            Locale('yo',), // Yo
            // const Locale('en'),
            // const Locale('fr'),
            // const Locale('ig'),
            // const Locale('yo'),
          ],
           localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return const Locale('en'); // Fallback locale
          },
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: app?.appName ?? "Node-Tech Canteen",
          theme: appProvider.theme,
          darkTheme: Constants.darkTheme,
    //   home: AuthStateListener(),
         
            onGenerateRoute: Routes.generateRoute,
      
        );
      },
    );
  }
}



