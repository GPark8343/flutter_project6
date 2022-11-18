import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/providers/channel_making.dart';
import 'package:ifc_project1/providers/opponent_user_ids.dart';

import 'package:ifc_project1/screens/chat_screen.dart';
import 'package:ifc_project1/screens/splash_screen.dart';
import 'package:ifc_project1/widgets/friends/friend-item.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChannelAddScreen extends StatefulWidget {
  static const routeName = '/friend-add';
  const ChannelAddScreen({super.key});

  @override
  State<ChannelAddScreen> createState() => _ChannelAddScreenState();
}

class _ChannelAddScreenState extends State<ChannelAddScreen> {
  @override
  Widget build(BuildContext context) {
    void goto(opponentUserIds, groupId) {
      Navigator.of(context)
          .pushReplacementNamed(ChatScreen.routeName, arguments: {
        'currentUserId': FirebaseAuth.instance.currentUser?.uid,
        'opponentUserIds': opponentUserIds,
        'groupId': groupId
      });
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  final channelMaking =
                      Provider.of<ChannelMaking>(context, listen: false);
                  var opponentUserIdsTool =
                      Provider.of<OpponentUserIds>(context, listen: false);
                  var opponentUserIds =
                      Provider.of<OpponentUserIds>(context, listen: false)
                          .opponentUserIds;

                  // var data = await FirebaseFirestore.instance
                  //     .collection("users")
                  //     .doc(FirebaseAuth.instance.currentUser?.uid)
                  //     .collection('groupinfo')
                  //     .where("oppoIds", isEqualTo: opponentUserIds)
                  //     .snapshots()
                  //     .first;
                  var allIds = [
                    FirebaseAuth.instance.currentUser?.uid,
                    ...opponentUserIds
                  ];
                  allIds.sort();
                  var data = await FirebaseFirestore.instance
                      .collection("groups")
                      .where("allIds", isEqualTo: allIds)
                      .snapshots()
                      .first;
                  var result = data.docs.isEmpty;
                  // [0].data()["allIds"];

                  if (!result || opponentUserIds.isEmpty) {
                    setState(() {});
                    //나 혼자서 대화하기 아님 이미 있는 채팅방 또 생성X
                    print(opponentUserIds);
                    print(data.docs[0].data());
                  } else {
                    print(opponentUserIds);
                    print(result);
                    final groupId = Uuid().v1();

                    await channelMaking.addChannel(
                        (FirebaseAuth.instance.currentUser?.uid).toString(),
                        opponentUserIds,
                        groupId); //

                    goto(opponentUserIds, groupId);
                  }
                  opponentUserIdsTool.clearOpponentUserIds();
                }
                // },
                )
          ],
          title: const Text('add your members'),
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
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        FriendItem(
                          friendDocs?[index]['username'],
                          friendDocs?[index]['image_url'],
                          friendDocs?[index]['uid'],
                        ),
                        const Divider(indent: 85),
                      ],
                    );
                  }),
            );
          },
        ));
  }
}
