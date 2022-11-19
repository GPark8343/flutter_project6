import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/widgets/chat/messages.dart';
import 'package:ifc_project1/widgets/chat/new_message.dart';
import 'package:ifc_project1/widgets/waiting/waiting_messages.dart';
import 'package:ifc_project1/widgets/waiting/waiting_new_message.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({super.key});
  static const routeName = '/waiting-room';

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserId =
        (ModalRoute.of(context)?.settings.arguments as Map)['currentUserId'];

    final groupId =
        (ModalRoute.of(context)?.settings.arguments as Map)['groupId'];

    final membersNum =
        (ModalRoute.of(context)?.settings.arguments as Map)['membersNum'];

    return Scaffold(
        appBar: AppBar(title: Text('대기방 이름')),
        body: Container(
          child: Column(
            children: [
              GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10.0),
                  itemCount: membersNum, //고치기
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (ctx, i) => ClipRRect(
                        child: Container(color: Colors.red),
                      )),
              Expanded(child: WaitingMessages(currentUserId, groupId)),
              WaitingNewMessage(currentUserId, groupId),
            ],
          ),
        ));
  }
}
