import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/screens/chat/chat_screen.dart';

import 'package:intl/intl.dart';

class ChannelListScreen extends StatelessWidget {
  const ChannelListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('groups')
              
              .snapshots(),
          builder: (ctx, channelSnapshot) {
            if (channelSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
            final channelDocs = channelSnapshot.data?.docs;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: channelDocs?.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await Navigator.of(context)
                            .pushNamed(ChatScreen.routeName, arguments: {
                          'currentUserId':
                              FirebaseAuth.instance.currentUser?.uid,
                   
                          'groupId': channelDocs[index]['groupId']
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            channelDocs![index]['groupId'].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              channelDocs[index]['last_message'].toString(),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          leading: CircleAvatar(
                            // backgroundImage: NetworkImage(
                            //   channelDocs[index][''].toString(),
                            // ),
                            backgroundColor: Colors.red,
                            radius: 30,
                          ),
                          trailing: Text(
                            DateFormat.Hm().format(
                                (channelDocs[index]['createdAt'] as Timestamp)
                                    .toDate()),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(indent: 85),
                  ],
                );
              },
            );
          },
        ));
  }
}
