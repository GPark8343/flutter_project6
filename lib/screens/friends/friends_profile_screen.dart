import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/providers/chat/add_friend.dart';
import 'package:provider/provider.dart';

class FriendsProfileScreen extends StatelessWidget {
  const FriendsProfileScreen({super.key});
  static const routeName = '/friends-profile';

  @override
  Widget build(BuildContext context) {
    final image =
        (ModalRoute.of(context)?.settings.arguments as Map)['image_url'];
    final username =
        (ModalRoute.of(context)?.settings.arguments as Map)['username'];
    final uid = (ModalRoute.of(context)?.settings.arguments as Map)['uid'];

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('friends')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          final userDocs = snapshot.data?.docs;
          final isFriends = userDocs?.any((element) => element['uid'] == uid);
          final isBan = isFriends!
              ? userDocs
                  ?.firstWhere((element) => element['uid'] == uid)
                  .data()['isBan']
              : false;
          print(isFriends);
          return Scaffold(
              appBar: AppBar(
                title: Text('profile'),
              ),
              body: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            image,
                          ),
                          radius: 64,
                        ),
                      ],
                    ),
                    Text(username),
                    isFriends
                        ? Container()
                        : TextButton(
                            onPressed: () {
                              final addFriend = //친추 기능
                                  Provider.of<AddFriend>(context,
                                      listen: false);
                              addFriend.addFriend(username, image, uid);
                            },
                            child: Text('친구 추가')),
                    isBan!
                        ? TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .collection('friends')
                                  .doc(uid)
                                  .update({'isBan': false});
                            },
                            child: Text('친구 차단 해제'))
                        : TextButton(
                            onPressed: () async {
                              isFriends
                                  ? await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .collection('friends')
                                      .doc(uid)
                                      .update({'isBan': true})
                                  : await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .collection('friends')
                                      .doc(uid)
                                      .set({
                                      'username':username,
                                      'image_url': image,
                                      'uid': uid,
                                      'isBan': true
                                    });
                            },
                            child: Text('친구 차단'))
                  ],
                ),
              ));
        });
  }
}
