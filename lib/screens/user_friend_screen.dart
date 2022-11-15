import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:ifc_project1/widgets/friends/friend-item.dart';


class UserFreindScreen extends StatelessWidget {
  const UserFreindScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    return StreamBuilder(
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
        return ListView.builder(
          itemCount: friendDocs?.length,
          itemBuilder: (context, index) => FriendItem(
             friendDocs?[index]['name'],
            friendDocs?[index]['userImage'],
          ),
        );
      },
    );
  }
}
