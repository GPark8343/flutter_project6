import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ifc_project1/providers/auth/user_check.dart';
import 'package:ifc_project1/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class AuthDataScreen extends StatefulWidget {
  static const routeName = '/auth-data';

  @override
  State<AuthDataScreen> createState() => _AuthDataScreenState();
}

enum Gender { NONE, MAN, WOMEN }

Gender _gender = Gender.NONE;

class _AuthDataScreenState extends State<AuthDataScreen> {
  final _schoolController = TextEditingController();
  final _departmentController = TextEditingController();

  void _submitData() async {
    final enteredSchool = _schoolController.text;
    final enteredDepartment = _departmentController.text;
    final genderString = _gender == Gender.MAN ? '남자' : '여자';

    if (enteredSchool.isEmpty ||
        enteredDepartment.isEmpty ||
        _gender == Gender.NONE) {
      return; // 조건문 만족하면 다음 함수 멈추기
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      'school': enteredSchool,
      'department': enteredDepartment,
      'gender': genderString,
    });
    Navigator.of(context).pop();
  }

  // Future<bool> onBackKey() async {
  //   return await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           backgroundColor: Color(0xff161619),
  //           title: Text(
  //             '끝?',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context, true);
  //               },
  //               child: Text(
  //                 '끝내기',
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 GoogleSignIn().signOut();
  //                 Navigator.pop(context, false);
  //               },
  //               child: Text(
  //                 '아니요',
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return
        // WillPopScope(
        // onWillPop: () {
        //   GoogleSignIn().signOut();
        //   return onBackKey();
        // },
        // child:
        Scaffold(
      appBar: AppBar(),
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
              SingleChildScrollView(
                child: Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                    // MediaQuery.of(context).viewInsets.bottom = 키보드 크기
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // CupertinoTextField(placeholder: ,), //ios 만들 때, 써라
                          TextField(
                            controller: _schoolController,
                            decoration:
                                const InputDecoration(labelText: 'school'),
                            onSubmitted: (_) => _submitData(),
                            // onChanged: (val) {
                            //   titleInput = val;
                            // },
                          ),
                          TextField(
                            controller: _departmentController,
                            decoration:
                                const InputDecoration(labelText: 'department'),
                            onSubmitted: (_) => _submitData(),
                            // onChanged: (val) {
                            //   titleInput = val;
                            // },
                          ),
                          RadioListTile(
                              title: Text('남자'),
                              value: Gender.MAN,
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  if (value != null) _gender = value as Gender;
                                });
                              }),
                          RadioListTile(
                              title: Text('여자'),
                              value: Gender.WOMEN,
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  if (value != null) _gender = value as Gender;
                                
                                });
                              }),
                          
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
              )
            ]),
          ),
        ),
      ),
    );
    // );
  }
}

//  @override
//   Widget build(BuildContext context) {

//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//           .snapshots(),
//       builder: (ctx, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: const CircularProgressIndicator(),
//           );
//         }
//         final userDocs = snapshot.data?.docs;
//         return Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: 1,
//                 itemBuilder: (context, index) {
//                   return FutureBuilder(
//                       future: userCheck.userCheck(),
//                       builder: (context, futureSnapshot) {
//                         return Column(
//                           children: [
//                             Container(
//                               color: Colors.yellow,
//                               child: InkWell(
//                                 onTap: () {},
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 8.0),
//                                   child: ListTile(
//                                     title: Text(
//                                       userDocs?[index]['username'],
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                     leading: CircleAvatar(
//                                       backgroundImage: NetworkImage(
//                                         userDocs?[index]['image_url'],
//                                       ),
//                                       radius: 30,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const Divider(indent: 85),

//                           ],
//                         );
//                       });
//                 }));
//       },
//     );

//   }
// }
