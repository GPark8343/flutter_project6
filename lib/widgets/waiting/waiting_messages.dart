import 'package:ifc_project1/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/widgets/waiting/waiting_message_bubble.dart';

class WaitingMessages extends StatelessWidget {
  final String currentUserId;

  final String groupId;

  WaitingMessages(this.currentUserId,  this.groupId);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('waiting-groups')
          .doc(groupId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data?.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs?.length,
          itemBuilder: (context, index) => WaitingMessageBubble(
            chatDocs?[index]['text'],
            FirebaseAuth.instance.currentUser?.uid ==
                chatDocs?[index]['userId'],
            chatDocs?[index]['username'],
            chatDocs?[index]['image_url'],
            key: ValueKey(chatDocs?[index].id),
          ),
        );
      },
    );
  }
}
