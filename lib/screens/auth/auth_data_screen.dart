import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDataScreen extends StatefulWidget {
  static const routeName = '/auth-data';

  @override
  State<AuthDataScreen> createState() => _AuthDataScreenState();
}

class _AuthDataScreenState extends State<AuthDataScreen> {
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
    final credential =
        (ModalRoute.of(context)?.settings.arguments as Map)['credential'];
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

  Future<bool> onBackKey() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xff161619),
            title: Text(
              '끝?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  '끝내기',
                ),
              ),
              TextButton(
                onPressed: () {
                  GoogleSignIn().signOut();
                  Navigator.pop(context, false);
                },
                child: Text(
                  '아니요',
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        GoogleSignIn().signOut();
        return onBackKey();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              // MediaQuery.of(context).viewInsets.bottom = 키보드 크기
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
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
        ),
      ),
    );
  }
}
