import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCheck with ChangeNotifier {
  bool isEnrolled = false;
  Future userCheck() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      if (value.data()?['gender'] != 'none' &&
          value.data()?['department'] != 'none' &&
          value.data()?['school'] != 'none') {
        isEnrolled = true;
        notifyListeners();
      } else {
        isEnrolled = false;
    
        notifyListeners();
      }    print(isEnrolled);
    });
  }
}
