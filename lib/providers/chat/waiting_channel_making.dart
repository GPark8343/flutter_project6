import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WaitingChannelMaking with ChangeNotifier {
  Future<void> waitingAddChannel(String currentUserId, List opponentsUserIds,
      String groupId, int membersNum, String title, String description) async {
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
      await FirebaseFirestore.instance
          .collection('waiting-groups')
          .doc(groupId)
          .set({
        'membersInfo': membersInfo,
        'groupId': groupId,
        'createdAt': Timestamp.now(),
        'allIds': allIds,
        'membersNum': membersNum,
        'title': title,
        'description': description
      });
    });

    // foreach 끝

    final user = FirebaseAuth.instance.currentUser;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    await FirebaseFirestore.instance //메시지 생성
        .collection('waiting-groups')
        .doc(groupId)
        .collection('messages')
        .add({
      'text': '웨이팅 채널 생성 완료',
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': userData['username'],
      'image_url': userData['image_url']
    });
  }

  Future<void> joinChannel(groupId) async {
    final currentUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    var membersInfo = await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .get();

    var list = [
      ...membersInfo['membersInfo'],
      {
        'memberId': currentUser['uid'],
        'membername': currentUser['username'],
        'member_image_url': currentUser['image_url']
      },
    ];

    // (membersInfo['membersInfo'] as List).add({
    //   'memberId': currentUser['uid'],
    //   'membername': currentUser['username'],
    //   'member_image_url': currentUser['image_url']
    // });

    await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .update({'membersInfo': list});
  }

  Future<void> inviteOthersChannel(String groupId, List userIds) async {
    var list = [];
    userIds.forEach((e) async {
      if (e != userIds[userIds.length - 1]) {
        var user =
            await FirebaseFirestore.instance.collection('users').doc(e).get();
        list.add({
          'memberId': user['uid'],
          'membername': user['username'],
          'member_image_url': user['image_url']
        });
      } else {
        var user =
            await FirebaseFirestore.instance.collection('users').doc(e).get();
        list.add({
          'memberId': user['uid'],
          'membername': user['username'],
          'member_image_url': user['image_url']
        });

        var membersInfo = await FirebaseFirestore.instance
            .collection('waiting-groups')
            .doc(groupId)
            .get();
        list = [...membersInfo['membersInfo'], ...list];
        print(list);
        await FirebaseFirestore.instance
            .collection('waiting-groups')
            .doc(groupId)
            .update({'membersInfo': list});
      }
    });
  }

  Future<void> exitChannel(groupId) async {
    final currentUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    var membersInfo = await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .get();

    var list = (membersInfo['membersInfo'] as List);

    list.removeWhere((items) => items['memberId'] == currentUser['uid']);

    // (membersInfo['membersInfo'] as List).add({
    //   'memberId': currentUser['uid'],
    //   'membername': currentUser['username'],
    //   'member_image_url': currentUser['image_url']
    // });

    await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .update({'membersInfo': list});
  }

  Future<void> deleteChannel(groupId) async {
    await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .collection('messages').get().then((snapshot) {
  for (DocumentSnapshot ds in snapshot.docs){
    ds.reference.delete();
  }});
    await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .delete();

 



  }

  Future<void> exitOthersChannel(String groupId, String userId) async {
    final currentUser =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    var membersInfo = await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .get();

    var list = (membersInfo['membersInfo'] as List);

    list.removeWhere((items) => items['memberId'] == currentUser['uid']);

    // (membersInfo['membersInfo'] as List).add({
    //   'memberId': currentUser['uid'],
    //   'membername': currentUser['username'],
    //   'member_image_url': currentUser['image_url']
    // });

    await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .update({'membersInfo': list});
  }
}
