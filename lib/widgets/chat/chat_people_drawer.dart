import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPeopleDrawer extends StatelessWidget {
  String groupId;

  ChatPeopleDrawer(this.groupId);

  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'People List!',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder(
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
                          ],
                        );
                      }));
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(groupId)
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data?.data();
              return
                  // ListView.builder(
                  //     shrinkWrap: true,
                  //     reverse: true,
                  //     itemCount: chatDocs?['membersInfo'].length,
                  //     itemBuilder: (context, index) => Container(
                  //           child: Text(chatDocs?['membersInfo'][index]['membername']),
                  //         ));
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatDocs?['membersInfo'].length,
                      itemBuilder: (context, index) {
                        return chatDocs?['membersInfo'][index]['memberId'] ==
                                FirebaseAuth.instance.currentUser?.uid
                            ? Container()
                            : Column(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: ListTile(
                                        title: Text(
                                          chatDocs?['membersInfo'][index]
                                              ['membername'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            chatDocs?['membersInfo'][index]
                                                ['member_image_url'],
                                          ),
                                          radius: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(indent: 85),
                                ],
                              );
                      }

                      //  FriendItem(
                      //    friendDocs?[index]['username'],
                      //   friendDocs?[index]['image_url'],
                      //   friendDocs?[index]['uid'],
                      // ),

                      );
            },
          )
        ],
      ),
    );
  }
}
