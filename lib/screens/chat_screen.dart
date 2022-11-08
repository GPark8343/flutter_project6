import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FlutterChat'),
          actions: [
            DropdownButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                items: [
                  DropdownMenuItem(
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Logout')
                        ],
                      ),
                    ),
                    value: 'logout',
                  )
                ],
                onChanged: (itemIdentifier) {
                  if (itemIdentifier == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                })
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/V6co6tub6dkk3QHWVDXF/messages')
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshot.data?.docs;
            return ListView.builder(
              itemCount: documents?.length,
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.all(8),
                child: Text(documents?[index]['text']),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('chats/V6co6tub6dkk3QHWVDXF/messages')
                  .add({'text': 'This was added by clicking the button!'});
            }));
  }
}
