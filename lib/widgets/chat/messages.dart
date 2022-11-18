import 'package:ifc_project1/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  final String currentUserId;

  final String groupId;

  Messages(this.currentUserId,  this.groupId);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('groups')
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
          itemBuilder: (context, index) => MessageBubble(
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
