import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/widgets/chat/messages.dart';
import 'package:ifc_project1/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat';
  @override
  Widget build(BuildContext context) {
    final currentUserId =
        (ModalRoute.of(context)?.settings.arguments as Map)['currentUserId'];
    final opponentUserIds =
        (ModalRoute.of(context)?.settings.arguments as Map)['opponentUserIds'];
    final groupId =
        (ModalRoute.of(context)?.settings.arguments as Map)['groupId'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          DropdownButton(
              underline: Container(),
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
                       const Text('Logout')
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
      body: Container(
        child: Column(
          children: [
            Expanded(child: Messages(currentUserId, opponentUserIds,groupId)),
            NewMessage(currentUserId, opponentUserIds,groupId)
          ],
        ),
      ),
    );
  }
}
