import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/screens/friends/friends_profile_screen.dart';

class BanScreen extends StatelessWidget {
  const BanScreen({super.key});
  static const routeName = '/ban';
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('ban-list'),),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('friends')
                .snapshots(),
            builder: (ctx, friendSnapshot) {
              if (friendSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
              final friendDocs = friendSnapshot.data?.docs;
              final banDocs =
                  friendDocs?.where((element) => element['isBan'] == true).toList();
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: banDocs?.length,
                    itemBuilder: (context, index) {
                      var isBan = banDocs?[index]['isBan'];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  FriendsProfileScreen.routeName,
                                  arguments: {
                                    'image_url': banDocs?[index]['image_url'],
                                    'username': banDocs?[index]['username'],
                                    'uid': banDocs?[index]['uid'],
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                  title: Text(
                                    banDocs?[index]['username'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      banDocs?[index]['image_url'],
                                    ),
                                    radius: 30,
                                  ),
                                  trailing: isBan!
                                      ? Text(
                                          '차단됨',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        )
                                      : null),
                            ),
                          ),
                          const Divider(indent: 85),
                        ],
                      );
                    }
    
                  
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
