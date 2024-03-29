import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/screens/friends/friends_profile_screen.dart';  
import 'package:ifc_project1/widgets/friends/my_profile.dart';

class UserFreindScreen extends StatelessWidget {
  const UserFreindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyProfile(),
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
            final friendDocs = friendSnapshot.data?.docs.where((element) => element['isBan'] == false).toList();;

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: friendDocs?.length,
                  itemBuilder: (context, index) {
                    var isBan =
                        friendDocs?[index]['isBan'];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                FriendsProfileScreen.routeName,
                                arguments: {
                                  'image_url': friendDocs?[index]['image_url'],
                                  'username': friendDocs?[index]['username'],
                                  'uid': friendDocs?[index]['uid'],
                                });
                          },
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

                  //  FriendItem(
                  //    friendDocs?[index]['username'],
                  //   friendDocs?[index]['image_url'],
                  //   friendDocs?[index]['uid'],
                  // ),

                  ),
            );
          },
        ),
      ],
    );
  }
}
