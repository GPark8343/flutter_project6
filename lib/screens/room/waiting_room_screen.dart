import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ifc_project1/providers/chat/waiting_channel_making.dart';
import 'package:ifc_project1/widgets/chat/messages.dart';
import 'package:ifc_project1/widgets/chat/new_message.dart';
import 'package:ifc_project1/widgets/waiting/waiting_messages.dart';
import 'package:ifc_project1/widgets/waiting/waiting_new_message.dart';
import 'package:ifc_project1/widgets/waiting/waiting_zone.dart';
import 'package:provider/provider.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({super.key});
  static const routeName = '/waiting-room';

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  bool isFull = false;
  bool isIn = false;
  bool isLeader = false;
  late Future myfuture;

  Future first(String groupId, num membersNum) async {
    await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .get()
        .then((value) async {
      var membersInfo = await FirebaseFirestore.instance
          .collection('waiting-groups')
          .doc(groupId)
          .get();

      isLeader = membersInfo['membersInfo'][0]['memberId'] ==
          FirebaseAuth.instance.currentUser?.uid;
    });

    await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .get()
        .then((value) async {
      var membersInfo = await FirebaseFirestore.instance
          .collection('waiting-groups')
          .doc(groupId)
          .get();

      isIn = (membersInfo['membersInfo'] as List).any((e) {
        return e['memberId'] == FirebaseAuth.instance.currentUser?.uid;
      });
    });
    await FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(groupId)
        .get()
        .then((value) {
      (value.data()?['membersInfo'] as List).length == membersNum
          ? isFull = true
          : isFull = false;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        (ModalRoute.of(context)?.settings.arguments as Map)['currentUserId'];

    final groupId =
        (ModalRoute.of(context)?.settings.arguments as Map)['groupId'];

    final membersNum =
        (ModalRoute.of(context)?.settings.arguments as Map)['membersNum'];

    Future<void> add() async {
      final waitingChannelMaking =
          Provider.of<WaitingChannelMaking>(context, listen: false);
      (isFull || isIn)
          ? null // 꽉 차면 대기열로 이동
          : waitingChannelMaking.joinChannel(groupId);
    }

    return FutureBuilder(
        future: first(groupId, membersNum),
        builder: (context, futureSnapshot) {
          return futureSnapshot.connectionState == ConnectionState.waiting
              ? Scaffold(appBar: AppBar(title: Text('채널 이동 중'),),
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    title: Text('대기방 이름'),
                    actions:isLeader?[ IconButton(
                                onPressed: () {
                           //실제 방으로 이동하기
                                },
                                icon: Icon(Icons.check))]:( (isIn || isFull)
                        ? []
                        : [
                            IconButton(
                                onPressed: () {
                                  add();
                                },
                                icon: Icon(Icons.add))
                          ]),
                  ),
                  body: Column(
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('waiting-groups')
                              .doc(groupId)
                              .snapshots(),
                          builder: (ctx, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: const CircularProgressIndicator(),
                              );
                            }
                            final userDocs =
                                userSnapshot.data?.data()?['membersInfo'];
                            return Column(
                              children: [
                                GridView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(10.0),
                                    itemCount: (userDocs as List).length, //고치기
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 3 / 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                    itemBuilder: (ctx, i) => ClipRRect(
                                          child: Container(
                                            color: Colors.red,
                                            child: GridTile(
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: FadeInImage(
                                                  placeholder: AssetImage(
                                                      'assets/images/person.png'),
                                                  image: NetworkImage(
                                                      userDocs[i]
                                                          ['member_image_url']),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: membersNum -
                                        (userDocs as List).length, //고치기
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 3 / 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                    itemBuilder: (ctx, i) => ClipRRect(
                                          child: Container(
                                            color: Colors.red,
                                          ),
                                        )),
                              ],
                            );
                          }),
                      Expanded(child: WaitingMessages(currentUserId, groupId)),
                      WaitingNewMessage(currentUserId, groupId),
                    ],
                  ),
                );
        });
  }
}
