import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ifc_project1/providers/auth/user_check.dart';

import 'package:ifc_project1/screens/chat/channel_add_screen.dart';
import 'package:ifc_project1/screens/chat/channel_list_screen.dart';
import 'package:ifc_project1/screens/chat/profile_screen.dart';
import 'package:ifc_project1/screens/chat/user_friend_screen.dart';
import 'package:ifc_project1/screens/chat/user_list_screen.dart';
import 'package:ifc_project1/screens/friends/ban_screen.dart';
import 'package:ifc_project1/screens/room/bulletin_board_screen.dart';
import 'package:ifc_project1/screens/room/room_add_screen.dart';
import 'package:ifc_project1/widgets/app_drawer.dart';

import 'package:provider/provider.dart';

class TapScreen extends StatefulWidget {
  const TapScreen({super.key});

  @override
  State<TapScreen> createState() => _TapScreenState();
}

class _TapScreenState extends State<TapScreen> {
  late List<Map<String, Object>> _pages; //
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {'page': ProfileScreen(), 'title': 'Profile'},
      {'page': BulletinBoardScreen(), 'title': 'BulletinBoard'},
      // {'page': PlaceListScreen(), 'title': 'List'},
      // {'page': MapScreen(), 'title': 'Map'},
      {'page': ChannelListScreen(), 'title': 'Chat'},
      // {'page': FilterScreen(), 'title': 'Filter'},
      {'page': UserFreindScreen(), 'title': 'Friend'},
      {'page': UserListScreen(), 'title': 'People'},
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCheck = Provider.of<UserCheck>(context, listen: false);
    var isEnrolled = userCheck.isEnrolled;
    return FutureBuilder(
        future: userCheck.userCheck(),
        builder: (context, futureSnapshot) {
          return Scaffold(drawer: AppDrawer(),
            appBar: !isEnrolled
                ? AppBar(
                    title: Text('먼저 양식 제출하셈'),
                    
                  )
                : AppBar(
                    title: Text(_pages[_selectedPageIndex]['title'] as String),
                    actions: _selectedPageIndex == 2
                        ? [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      BanScreen.routeName);
                                },
                                icon: Icon(Icons.extension_off_rounded)),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(ChannelAddScreen.routeName);
                                },
                                icon: Icon(Icons.add)),
                          ]
                        : _selectedPageIndex == 4
                            ? [
                               
                              ]
                            : _selectedPageIndex == 1
                                ? [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(RoomAddScreen.routeName);
                                      },
                                      icon: Icon(Icons.edit),
                                    )
                                  ]
                                : [],
                  ),
            body: !isEnrolled
                ? _pages[0]['page'] as Widget
                : _pages[_selectedPageIndex]['page'] as Widget,
            bottomNavigationBar: BottomNavigationBar(
                onTap: _selectPage,
                backgroundColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.white,
                selectedItemColor: Theme.of(context).accentColor,
                currentIndex: _selectedPageIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.aspect_ratio_rounded),
                      label: 'Profile'),
                  BottomNavigationBarItem(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.panorama_fisheye_outlined),
                      label: 'BulletinBoard'),
                  // BottomNavigationBarItem(
                  //     backgroundColor: Theme.of(context).primaryColor,
                  //     icon: Icon(Icons.category),
                  //     label: 'list'),
                  // BottomNavigationBarItem(
                  //     backgroundColor: Theme.of(context).primaryColor,
                  //     icon: Icon(Icons.map),
                  //     label: 'map'),
                  BottomNavigationBarItem(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.chat),
                      label: 'chat'),
                  // BottomNavigationBarItem(
                  //     backgroundColor: Theme.of(context).primaryColor,
                  //     icon: Icon(Icons.filter),
                  //     label: 'filter'),
                  BottomNavigationBarItem(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.people),
                      label: 'friend'),
                  BottomNavigationBarItem(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.people_alt_rounded),
                      label: 'people'),
                ]),
          );
        });
  }
}
