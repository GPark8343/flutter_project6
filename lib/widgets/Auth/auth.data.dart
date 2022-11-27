

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthData extends StatefulWidget {
  final googleUser;
  AuthData(this.googleUser);

  @override
  State<AuthData> createState() => _AuthDataState();
}

class _AuthDataState extends State<AuthData> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  void _submitData() async {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return; // 조건문 만족하면 다음 함수 멈추기
    }
     final GoogleSignInAuthentication? googleAuth =
          await widget.googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
    final authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final user = authResult.user;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user?.uid)
        .set({
      'username': user?.displayName,
      'email': user?.email,
      'image_url': user?.photoURL,
      'uid': authResult.user?.uid
    });
    // widget.addTx(enteredTitle, enteredAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          // MediaQuery.of(context).viewInsets.bottom = 키보드 크기
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            // CupertinoTextField(placeholder: ,), //ios 만들 때, 써라
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              onSubmitted: (_) => _submitData(),
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
              onSubmitted: (_) => _submitData(),
              // onChanged: (val) {
              //   amountInput = val;
              // },
            ),

            ElevatedButton(
              child: const Text('Add Transaction'),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor),
              onPressed: _submitData,
            )
          ]),
        ),
      ),
    );
  }
}
