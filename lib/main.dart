import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'business/business_library.dart';
import 'location/location_library.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BusinessProvider>(
          create: (_) => BusinessProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'Names',
          theme: ThemeData(
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // theme: ThemeData(
          //   // Define the default brightness and colors.
          //   brightness: Brightness.dark,
          //   // toggleableActiveColor:Colors.pink ,
          //   // textSelectionColor: Colors.pink,
          //   // buttonTheme: ButtonThemeData(
          //   //   textTheme: ButtonTextTheme.primary,
          //   //  // colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.pink),
          //   // ),

          // ),
          //darkTheme: ThemeData.dark(),
          home: BusinessesOverviewScreen(),
          routes: {
            BusinessScreen.routeName: (ctx) => BusinessScreen(),
            BusinessFilterScreen.routeName: (ctx) => BusinessFilterScreen(),
            LocationSelectScreen.routeName: (context) => LocationSelectScreen(),
            BusinessAddScreen.routeName: (context) => BusinessAddScreen(),
            ItemAddScreen.routeName: (context) => ItemAddScreen(),
          }),
    );
  }
}
