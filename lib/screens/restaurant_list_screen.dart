import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RestaurantListScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('place-list').orderBy('distance', descending: false)
          .snapshots(),
      builder: (ctx, placeSnapshot) {
        if (placeSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final placeDocs = placeSnapshot.data?.docs;
        return ListView.builder(
            itemCount: placeDocs?.length,
            itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    // backgroundImage: FileImage(File(placeDocs?[index]['image'])),  // 이거 오류 걍 내가 이미지 넣자 어차피 가게별 이미지 존재 X
                  ),
                  title: Text(placeDocs?[index]['name']),
                  subtitle: Text('${placeDocs?[index]['distance']}m'),
                ));
      },
    );
  }
}
