import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ifc_project1/screens/chat_screen.dart';
import 'package:ifc_project1/widgets/friends/friend-item.dart';
import 'package:provider/provider.dart';

class FriendAddScreen extends StatefulWidget {
  static const routeName = '/friend-add';
  const FriendAddScreen({super.key});

  @override
  State<FriendAddScreen> createState() => _FriendAddScreenState();
}

class _FriendAddScreenState extends State<FriendAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pushNamed(ChatScreen.routeName,
                    arguments: {
                      'currentUserId': FirebaseAuth.instance.currentUser?.uid,
                      'selectedUserId': []
                    });
              },
            )
          ],
          title: Text('add your members'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('friends')
              .snapshots(),
          builder: (ctx, friendSnapshot) {
            if (friendSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final friendDocs = friendSnapshot.data?.docs;
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: friendDocs?.length,
                itemBuilder: (context, index) => FriendItem(
                  friendDocs?[index]['name'],
                  friendDocs?[index]['userImage'],
                ),
              ),
            );
          },
        ));
  }
}
