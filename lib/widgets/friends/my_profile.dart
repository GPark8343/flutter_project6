import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    _userCheck();
    super.initState();
  }
   bool isEnrolled = true;
  Future? _userCheck() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      if (value.data()?['gender'] != 'none') {
        isEnrolled = true;
      } else {
        isEnrolled = false;
      }
    });
  }
  final _schoolController = TextEditingController();
  final _departmentController = TextEditingController();
  final _genderController = TextEditingController();

  void _submitData() async {
    final enteredSchool = _schoolController.text;
    final enteredDepartment = _departmentController.text;
    final enteredGender = _genderController.text;

    if (enteredSchool.isEmpty ||
        enteredDepartment.isEmpty ||
        enteredGender.isEmpty) {
      return; // 조건문 만족하면 다음 함수 멈추기
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      'school': enteredSchool,
      'department': enteredDepartment,
      'gender': enteredGender,
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
        final userDocs = snapshot.data?.docs;
        return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        color: Colors.yellow,
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                userDocs?[index]['username'],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  userDocs?[index]['image_url'],
                                ),
                                radius: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(indent: 85),
                     !isEnrolled? SingleChildScrollView(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        10),
                            // MediaQuery.of(context).viewInsets.bottom = 키보드 크기
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // CupertinoTextField(placeholder: ,), //ios 만들 때, 써라
                                  TextField(
                                    controller: _schoolController,
                                    decoration: const InputDecoration(
                                        labelText: 'school'),
                                    onSubmitted: (_) => _submitData(),
                                    // onChanged: (val) {
                                    //   titleInput = val;
                                    // },
                                  ),
                                  TextField(
                                    controller: _departmentController,
                                    decoration: const InputDecoration(
                                        labelText: 'department'),
                                    onSubmitted: (_) => _submitData(),
                                    // onChanged: (val) {
                                    //   titleInput = val;
                                    // },
                                  ),
                                  TextField(
                                    controller: _genderController,
                                    decoration: const InputDecoration(
                                        labelText: 'gender'),
                                    onSubmitted: (_) => _submitData(),
                                    // onChanged: (val) {
                                    //   titleInput = val;
                                    // },
                                  ),
                                  ElevatedButton(
                                    child: const Text('submit'),
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Theme.of(context).primaryColor),
                                    onPressed: _submitData,
                                  )
                                ]),
                          ),
                        ),
                      ):Container()
                    ],
                  );
                }));
      },
    );
    ;
  }
}
