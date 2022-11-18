import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/providers/channel_making.dart';
import 'package:ifc_project1/providers/all_ids.dart';

import 'package:ifc_project1/screens/chat_screen.dart';
import 'package:ifc_project1/screens/splash_screen.dart';
import 'package:ifc_project1/widgets/chat/channel_add-button.dart';
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


   var isLoading = false;
  @override
  Widget build(BuildContext context) {


    

    return Scaffold(
        appBar: AppBar(
          actions: [
         ChannelAddButton()
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
