import 'package:ifc_project1/colors.dart';
import 'package:ifc_project1/providers/auth/user_check.dart';
import 'package:ifc_project1/providers/chat/add_friend.dart';
import 'package:ifc_project1/providers/chat/all_ids.dart';
import 'package:ifc_project1/providers/chat/all_ids_invite.dart';
import 'package:ifc_project1/providers/chat/channel_making.dart';
import 'package:ifc_project1/providers/chat/is-add.dart';
import 'package:ifc_project1/providers/chat/waiting_channel_making.dart';
import 'package:ifc_project1/providers/place/current_location.dart';
import 'package:ifc_project1/providers/place/filter.dart';

import 'package:ifc_project1/providers/place/rating.dart';
import 'package:ifc_project1/screens/auth/auth_data_screen.dart';
import 'package:ifc_project1/screens/chat/channel_add_screen.dart';
import 'package:ifc_project1/screens/chat/chat_screen.dart';
import 'package:ifc_project1/screens/chat/waiting_channel_add_screen.dart';
import 'package:ifc_project1/screens/friends/ban_screen.dart';
import 'package:ifc_project1/screens/friends/friends_profile_screen.dart';

import 'package:ifc_project1/screens/place/place_detail_screen.dart';
import 'package:ifc_project1/screens/room/room_add_screen.dart';
import 'package:ifc_project1/screens/room/waiting_room_screen.dart';
import 'package:provider/provider.dart';

import 'screens/auth/auth_screen.dart';
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
        providers: [
          ChangeNotifierProvider.value(
            value: CurrentLocation(),
          ),
          ChangeNotifierProvider.value(
            value: Filter(),
          ),
          ChangeNotifierProvider.value(
            value: Rating(),
          ),
          ChangeNotifierProvider.value(
            value: IsAdd(),
          ),
          ChangeNotifierProvider.value(
            value: AddFriend(),
          ),
          ChangeNotifierProvider.value(
            value: ChannelMaking(),
          ),
          ChangeNotifierProvider.value(
            value: AllIds(),
          ),
          ChangeNotifierProvider.value(
            value: WaitingChannelMaking(),
          ),
          ChangeNotifierProvider.value(
            value: AllIdsInvite(),
          ),
          ChangeNotifierProvider.value(
            value: UserCheck(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterChat',
          theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (userSnapshot
                  .hasData /*|| FirebaseAuth.instance.currentUser != null*/) {
                return TapScreen();
              } else
                return AuthScreen();
            },
          ),
          routes: {
            PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
            ChatScreen.routeName: (ctx) => ChatScreen(),
            ChannelAddScreen.routeName: (ctx) => ChannelAddScreen(),
            SplashScreen.routeName: (ctx) => SplashScreen(),
            WaitingRoomScreen.routeName: (ctx) => WaitingRoomScreen(),
            RoomAddScreen.routeName: (ctx) => RoomAddScreen(),
            FriendsProfileScreen.routeName: (ctx) => FriendsProfileScreen(),
            BanScreen.routeName: (ctx) => BanScreen(),
            WaitingChannelAddScreen.routeName: (ctx) =>
                WaitingChannelAddScreen(),
            AuthDataScreen.routeName: (ctx) => AuthDataScreen(),
          },
        ));
  }
}
