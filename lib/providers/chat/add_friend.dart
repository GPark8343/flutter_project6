import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFriend with ChangeNotifier {
  void addFriend(String name, String userImage, String uid) async {
    // final userData = await FirebaseFirestore.instance.collection('users').get();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('friends')
        .doc(uid)
        .set({
      'username': name,
      'image_url': userImage,
      'uid': uid,
      'isBan': false
    });
  }
}
