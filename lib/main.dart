import 'package:ifc_project1/providers/current_location.dart';
import 'package:ifc_project1/providers/filter.dart';
import 'package:ifc_project1/providers/rating.dart';
import 'package:ifc_project1/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

import '../screens/auth_screen.dart';
import '../screens/tap_screen.dart';
import '../screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ ChangeNotifierProvider.value(
            value: CurrentLocation(),
          ),
          ChangeNotifierProvider.value(
            value: Filter(),
          ),
          ChangeNotifierProvider.value(
            value: Rating(),
          ),
        ],
        child: MaterialApp(
          title: 'FlutterChat',
          theme: ThemeData(
              primarySwatch: Colors.pink,
              backgroundColor: Colors.pink,
              accentColor: Colors.deepPurple,
              accentColorBrightness: Brightness.dark,
              buttonTheme: ButtonTheme.of(context).copyWith(
                  buttonColor: Colors.pink,
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (userSnapshot
                  .hasData /*|| FirebaseAuth.instance.currentUser != null*/) {
                return TapScreen();
              }
              return AuthScreen();
            },
          ),
          routes: {
             PlaceDetailScreen.routeName:(ctx) => PlaceDetailScreen(),
          },
        ));
  }
}
