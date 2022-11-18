import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChannelMaking with ChangeNotifier {
  Future<void> addChannel(
      String currentUserId, List opponentsUserIds, String groupId) async {
    opponentsUserIds.sort();
    List membersInfo = [];
    final allIds = [currentUserId, ...opponentsUserIds];
    allIds.sort();
    allIds.forEach((e) async {
      final userData =
          await FirebaseFirestore.instance.collection('users').doc(e).get();
      membersInfo.add({
        'memberId': userData['uid'],
        'membername': userData['username'],
        'member_image_url': userData['image_url']
      });
      await FirebaseFirestore.instance.collection('groups').doc(groupId).set({
        'membersInfo': membersInfo,
        'groupId': groupId,
        'last_message': '채널 생성 완료',
        'createdAt': Timestamp.now(),
        'allIds': allIds,
        ' oppoIds': opponentsUserIds
      });
    });

    // foreach 끝

    final user = FirebaseAuth.instance.currentUser;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    await FirebaseFirestore.instance //메시지 생성
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add({
      'text': '채널 생성 완료',
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': userData['username'],
      'image_url': userData['image_url']
    });
  }

  Future<void> getChannel() async {}
}
