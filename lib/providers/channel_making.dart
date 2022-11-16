import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChannelMaking with ChangeNotifier {
 

  Future<void> oneToOneAddChannel(
      String currentUserId, String opponentsUserId) async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    final oppoUserData = await FirebaseFirestore.instance
        .collection('users')
        .doc(opponentsUserId)
        .get();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(opponentsUserId)
        .collection('messages')
        .add({
      'text': '채널 생성 완료',
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': userData['username'],
      'image_url': userData['image_url']
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(opponentsUserId)
        .set({
      'oppoId': opponentsUserId,
      'opponame': oppoUserData['username'],
      'oppo_image_url': oppoUserData['image_url'],
      'last_message': '채널 생성 완료', 
      'createdAt': Timestamp.now(),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(opponentsUserId)
        .collection('chats')
        .doc(currentUserId)
        .collection('messages')
        .add({
      'text': '채널 생성 완료',
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': userData['username'],
      'image_url': userData['image_url']
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(opponentsUserId)
        .collection('chats')
        .doc(currentUserId)
        .set({
      'oppoId': user?.uid,
      'opponame': userData['username'],
      'oppo_image_url': userData['image_url'],
      'last_message': '채널 생성 완료',
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> getChannel() async {}
}
