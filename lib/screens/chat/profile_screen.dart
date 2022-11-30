import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:ifc_project1/providers/auth/user_check.dart';
import 'package:ifc_project1/screens/auth/auth_data_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    final userCheck = Provider.of<UserCheck>(context, listen: false);
    userCheck.userCheck();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userCheck = Provider.of<UserCheck>(context, listen: false);
    var isEnrolled = userCheck.isEnrolled;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (ctx, snapshot) {
        final userDocs = snapshot.data?.docs;
        if (snapshot.connectionState == ConnectionState.waiting ||
            userDocs!.isEmpty) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }

        return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: userCheck.userCheck(),
                      builder: (context, futureSnapshot) {
                        return futureSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                children: [
                                  Container(
                                    color: Colors.yellow,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
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
                                          trailing: IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                  AuthDataScreen.routeName);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(indent: 85),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .snapshots(),
                                      builder: (ctx, snapshot) {
                                        final userDocs = snapshot.data?.data();
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child:
                                                const CircularProgressIndicator(),
                                          );
                                        }

                                        return Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                  'school: ${userDocs?['school']}'),
                                            ),
                                            ListTile(
                                              title: Text(
                                                  'department: ${userDocs?['department']}'),
                                            ),
                                            ListTile(
                                              title: Text(
                                                  'gender: ${userDocs?['gender']}'),
                                            )
                                          ],
                                        );
                                      })
                                ],
                              );
                      });
                }));
      },
    );
  }
}
