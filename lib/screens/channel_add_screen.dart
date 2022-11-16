import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/providers/channel_making.dart';
import 'package:ifc_project1/providers/opponent_user_id.dart';

import 'package:ifc_project1/screens/chat_screen.dart';
import 'package:ifc_project1/widgets/friends/friend-item.dart';
import 'package:provider/provider.dart';

class ChannelAddScreen extends StatefulWidget {
  static const routeName = '/friend-add';
  const ChannelAddScreen({super.key});

  @override
  State<ChannelAddScreen> createState() => _ChannelAddScreenState();
}

class _ChannelAddScreenState extends State<ChannelAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                final channelMaking =
                    Provider.of<ChannelMaking>(context, listen: false);
                var opponentUserId =
                    Provider.of<OpponentUserId>(context, listen: false)
                        .opponentUserId;
                await channelMaking.oneToOneAddChannel(
                    (FirebaseAuth.instance.currentUser?.uid).toString(),
                    opponentUserId); //
                await Navigator.of(context)
                    .pushNamed(ChatScreen.routeName, arguments: {
                  'currentUserId': FirebaseAuth.instance.currentUser?.uid,
                  'opponentUserId': opponentUserId //
                });
              },
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
                        InkWell(
                          onTap: () {
                            var opponentUserId = Provider.of<OpponentUserId>(
                                context,
                                listen: false);
                            opponentUserId.changeOpponentUserId(
                                friendDocs?[index]['uid']);
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
                                trailing: Icon(Icons.circle)),
                          ),
                        ),
                        const Divider(indent: 85),
                      ],
                    );

                    // FriendItem(
                    //   friendDocs?[index]['username'],
                    //   friendDocs?[index]['image_url'],
                    //   friendDocs?[index]['uid'],
                    // );
                  }),
            );
          },
        ));
  }
}
