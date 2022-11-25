import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/providers/chat/all_ids.dart';
import 'package:ifc_project1/providers/chat/all_ids_invite.dart';
import 'package:ifc_project1/providers/chat/channel_making.dart';
import 'package:ifc_project1/providers/chat/waiting_channel_making.dart';

import 'package:ifc_project1/screens/chat/chat_screen.dart';
import 'package:ifc_project1/widgets/friends/friend-item-invite.dart';

import 'package:ifc_project1/widgets/friends/friend-item.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class WaitingChannelAddScreen extends StatefulWidget {
  static const routeName = '/waiting-channel-add';
  const WaitingChannelAddScreen({super.key});

  @override
  State<WaitingChannelAddScreen> createState() =>
      _WaitingChannelAddScreenState();
}

class _WaitingChannelAddScreenState extends State<WaitingChannelAddScreen> {
  var isLoading = false;

  void setStateTool() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final leftNumbers = (ModalRoute.of(context)?.settings.arguments
        as Map)['left-numbers']; //얘보다 크면 안됨
    final groupId =
        (ModalRoute.of(context)?.settings.arguments as Map)['groupId'];
    return Scaffold(
        appBar: AppBar(
          actions: isLoading
              ? []
              : [
                  IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        var userIds =
                            Provider.of<AllIdsInvite>(context, listen: false)
                                .idsList;
                        var userIdsTool =
                            Provider.of<AllIdsInvite>(context, listen: false);

                        if (userIds.length > leftNumbers || userIds.isEmpty) {
                          setState(() {});
                          print(userIds.length);
                          //남은방 수 초과 아님 이미 있는 채팅방 또 생성X

                        } else {
                          setStateTool();
                          final waitingChannelMaking =
                              Provider.of<WaitingChannelMaking>(context,
                                  listen: false);

                          waitingChannelMaking.inviteOthersChannel(
                              groupId, userIds);
                        }
                        userIdsTool.clearaddAllIds();
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
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
                        FriendItemInvite(
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
