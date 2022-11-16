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
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
              itemCount: friendDocs?.length,
              itemBuilder: (context, index) => Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                              title: Text(
                                friendDocs?[index]['username'],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  friendDocs?[index]['image_url'],
                                ),
                                radius: 30,
                              ),
                              ),
                        ),
                      ),
                      const Divider(indent: 85),
                    ],
                  )

              //  FriendItem(
              //    friendDocs?[index]['username'],
              //   friendDocs?[index]['image_url'],
              //   friendDocs?[index]['uid'],
              // ),

              ),
        );
      },
    );
  }
}
