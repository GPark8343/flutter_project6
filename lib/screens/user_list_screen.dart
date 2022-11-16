import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/info.dart';
import 'package:ifc_project1/providers/add_friend.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
        final userDocs = userSnapshot.data?.docs;
        return ListView.builder(
            itemCount: userDocs?.length,
            itemBuilder: (context, index) => Column(
                  children: [
                    InkWell(
                      onTap: () {
                        final addFriend =
                            Provider.of<AddFriend>(context, listen: false);
                        addFriend.addFriend(
                            userDocs[index]["username"],
                            userDocs[index]["image_url"],
                            userDocs[index]["uid"]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            userDocs![index]['username'],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(indent: 85),
                  ],
                ));
      },
    );
  }
}
