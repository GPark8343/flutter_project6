import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/providers/chat/channel_making.dart';
import 'package:ifc_project1/providers/chat/waiting_channel_making.dart';
import 'package:ifc_project1/screens/chat/chat_screen.dart';
import 'package:ifc_project1/screens/chat/waiting_channel_add_screen.dart';
import 'package:ifc_project1/screens/friends/friends_profile_screen.dart';
import 'package:ifc_project1/widgets/waiting/waiting_messages.dart';
import 'package:ifc_project1/widgets/waiting/waiting_new_message.dart';
import 'package:provider/provider.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({super.key});
  static const routeName = '/waiting-room';

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  var isLoading = false;
  bool isFull = false;
  bool isFullMen = false;
  bool isFullWomen = false;
  bool isIn = false;
  bool isLeader = false;
  late Future myfuture;

  Future first(String groupId, num membersNum) async {
    if (!isLoading) {
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
      // await FirebaseFirestore.instance
      //     .collection('waiting-groups')
      //     .doc(groupId)
      //     .get()
      //     .then((value) {
      //   (value.data()?['membersInfo'] as List).length == membersNum
      //       ? isFull = true
      //       : isFull = false;
      // });
      await FirebaseFirestore.instance
          .collection('waiting-groups')
          .doc(groupId)
          .get()
          .then((value) {
        (value.data()?['membersInfo'] as List)
                    .where((e) => e['member_gender'] == '여자')
                    .toList()
                    .length ==
                membersNum / 2
            ? isFullWomen = true
            : isFullWomen = false;
        ;
      });
      await FirebaseFirestore.instance
          .collection('waiting-groups')
          .doc(groupId)
          .get()
          .then((value) {
        (value.data()?['membersInfo'] as List)
                    .where((e) => e['member_gender'] == '남자')
                    .toList()
                    .length ==
                membersNum / 2
            ? isFullMen = true
            : isFullMen = false;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((value) {
        value.data()?['gender'] == '남자'
            ? isFull = isFullMen
            : isFull = isFullWomen;
      });
      return null;
    }
  }

  void goto(String groupId, BuildContext context) {
    Navigator.of(context).pushReplacementNamed(ChatScreen.routeName,
        arguments: {
          'currentUserId': FirebaseAuth.instance.currentUser?.uid,
          'groupId': groupId
        });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        (ModalRoute.of(context)?.settings.arguments as Map)['currentUserId'];

    final groupId =
        (ModalRoute.of(context)?.settings.arguments as Map)['groupId'];

    final membersNum =
        (ModalRoute.of(context)?.settings.arguments as Map)['membersNum'];
    var half = int.tryParse('${membersNum / 2}');
    Future<void> add() async {
      setState(() {});
      final waitingChannelMaking =
          Provider.of<WaitingChannelMaking>(context, listen: false);
      (isFull || isIn)
          ? null // 꽉 차면 대기열로 이동
          : waitingChannelMaking.joinChannel(groupId);
    }

    Future<void> exit() async {
      setState(() {});
      final waitingChannelMaking =
          Provider.of<WaitingChannelMaking>(context, listen: false);

      waitingChannelMaking.exitChannel(groupId);
    }

    Future<void> deleteWaitingChannel() async {
      final waitingChannelMaking =
          Provider.of<WaitingChannelMaking>(context, listen: false);

      waitingChannelMaking.deleteChannel(groupId);
    }

    Future<void> exitOthers(userId) async {
      setState(() {});
      final waitingChannelMaking =
          Provider.of<WaitingChannelMaking>(context, listen: false);

      waitingChannelMaking.exitOthersChannel(groupId, userId);
    }

    return FutureBuilder(
        future: first(groupId, membersNum),
        builder: (context, futureSnapshot) {
          return futureSnapshot.connectionState == ConnectionState.waiting
              ? Scaffold(
                  appBar: AppBar(  leading: isLoading
              ? IconButton(
                  icon: Icon(Icons.arrow_back), // <- 아이콘도 동일한 것을 사용
                  onPressed: () {
                    // <- 이전 페이지로 이동.
                  },
                )
              : IconButton(
                  icon: Icon(Icons.arrow_back), // <- 아이콘도 동일한 것을 사용
                  onPressed: () {
                    Navigator.pop(context); // <- 이전 페이지로 이동.
                  },
                ),
                    title: Text('채널 이동 중'),
                  ),
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(  leading: isLoading
              ? IconButton(
                  icon: Icon(Icons.arrow_back), // <- 아이콘도 동일한 것을 사용
                  onPressed: () {
                    // <- 이전 페이지로 이동.
                  },
                )
              : IconButton(
                  icon: Icon(Icons.arrow_back), // <- 아이콘도 동일한 것을 사용
                  onPressed: () {
                    Navigator.pop(context); // <- 이전 페이지로 이동.
                  },
                ),
                    title: Text('대기방 이름'),
                    actions: isLoading
                        ? []
                        : isLeader
                            ? [
                                IconButton(
                                    onPressed: () async {
                                      var membersInfo = await FirebaseFirestore
                                          .instance
                                          .collection('waiting-groups')
                                          .doc(groupId)
                                          .get();

                                      Navigator.of(context).pop();
                                      if ((membersInfo['membersInfo'] as List)
                                              .length ==
                                          1) {
                                        await deleteWaitingChannel();
                                      } else {
                                        await exit();
                                      }
                                    },
                                    icon: Icon(Icons.exit_to_app)),
                                IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      final channelMaking =
                                          Provider.of<ChannelMaking>(context,
                                              listen: false);
                                      await channelMaking
                                          .changeRealChannel(groupId);
                                      goto(groupId, context);
                                      await deleteWaitingChannel();
                                    },
                                    icon: Icon(Icons.check))
                              ]
                            : (isIn
                                ? [
                                    IconButton(
                                        onPressed: () {
                                          exit();
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.exit_to_app))
                                  ]
                                : (isFull
                                    ? []
                                    : [
                                        IconButton(
                                            onPressed: () {
                                              add();
                                            },
                                            icon: Icon(Icons.add))
                                      ])),
                  ),
                  body: StreamBuilder(
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
                        final creatorId =
                            userSnapshot.data?.data()?['creatorId'];
                        final userDocs =
                            userSnapshot.data?.data()?['membersInfo'] ?? [];
                        final menList = (userDocs as List)
                            .where(
                                (element) => element['member_gender'] == '남자')
                            .toList();
                        final womenList = (userDocs as List)
                            .where(
                                (element) => element['member_gender'] == '여자')
                            .toList();

                        return Column(
                          children: [
                            GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(10.0),
                                itemCount: membersNum, //고치기
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 3 / 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemBuilder: (ctx, i) {
                                  var halfI1 = (i / 2).toInt();
                                  var halfI2 = ((i - 1) / 2).toInt();
                                  if (i % 2 == 0) {
                                    print(halfI1);
                                    //남자
                                    if (menList.length > halfI1) {
                                      return ClipRRect(
                                        child: Container(
                                          color: Colors.blue,
                                          child: GridTile(
                                            child: GestureDetector(
                                              onTap: () {
                                                menList[halfI1]['memberId'] ==
                                                        FirebaseAuth.instance
                                                            .currentUser?.uid
                                                    ? null
                                                    : showModalBottomSheet(
                                                        context: ctx,
                                                        builder: (_) {
                                                          return GestureDetector(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                isLeader
                                                                    ? TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          exitOthers(menList[halfI1]
                                                                              [
                                                                              'memberId']);
                                                                        },
                                                                        child: Text(
                                                                            '방출'))
                                                                    : Container(
                                                                        height:
                                                                            0,
                                                                      ),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                        '갠톡')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.of(context).pushNamed(
                                                                          FriendsProfileScreen
                                                                              .routeName,
                                                                          arguments: {
                                                                            'image_url':
                                                                                menList[halfI1]['member_image_url'],
                                                                            'username':
                                                                                menList[halfI1]['membername'],
                                                                            'uid':
                                                                                menList[halfI1]['memberId'],
                                                                          });
                                                                    },
                                                                    child: Text(
                                                                        '프로필')),
                                                              ],
                                                            ),
                                                            behavior:
                                                                HitTestBehavior
                                                                    .opaque, //background만 눌러서 모델 닫히게 하기
                                                          );
                                                        },
                                                      );
                                              },
                                              child: FadeInImage(
                                                placeholder: AssetImage(
                                                    'assets/images/person.png'),
                                                image: NetworkImage(
                                                    menList[halfI1]
                                                        ['member_image_url']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            footer: creatorId ==
                                                    menList[halfI1]['memberId']
                                                ? GridTileBar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            221, 88, 84, 84),
                                                    title: Center(
                                                      child: Text(
                                                          '${menList[halfI1]['membername']}(방장)'),
                                                    ))
                                                : GridTileBar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            221, 88, 84, 84),
                                                    title: Center(
                                                      child: Text(
                                                          '${menList[halfI1]['membername']}'),
                                                    )),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return isLeader
                                          ? ClipRRect(
                                              child: Container(
                                                color: Colors.blue,
                                                child: GridTile(
                                                    child: IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            WaitingChannelAddScreen
                                                                .routeName,
                                                            arguments: {
                                                          'groupId': groupId,
                                                          'left-men-numbers':
                                                              membersNum / 2 -
                                                                  (userDocs
                                                                          as List)
                                                                      .where((e) =>
                                                                          e['member_gender'] ==
                                                                          '남자')
                                                                      .toList()
                                                                      .length,
                                                          'left-women-numbers':
                                                              membersNum / 2 -
                                                                  (userDocs
                                                                          as List)
                                                                      .where((e) =>
                                                                          e['member_gender'] ==
                                                                          '여자')
                                                                      .toList()
                                                                      .length
                                                        });
                                                  },
                                                )),
                                              ),
                                            )
                                          : ClipRRect(
                                              child: Container(
                                                  child: Text('남자'),
                                                  color: Colors.blue),
                                            );
                                    }
                                  } else {
                                    //여자

                                    if (womenList.length > halfI2) {
                                      return ClipRRect(
                                        child: Container(
                                          color: Colors.red,
                                          child: GridTile(
                                            child: GestureDetector(
                                              onTap: () {
                                                womenList[halfI2]['memberId'] ==
                                                        FirebaseAuth.instance
                                                            .currentUser?.uid
                                                    ? null
                                                    : showModalBottomSheet(
                                                        context: ctx,
                                                        builder: (_) {
                                                          return GestureDetector(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                isLeader
                                                                    ? TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          exitOthers(womenList[halfI2]
                                                                              [
                                                                              'memberId']);
                                                                        },
                                                                        child: Text(
                                                                            '방출'))
                                                                    : Container(
                                                                        height:
                                                                            0,
                                                                      ),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                        '갠톡')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.of(context).pushNamed(
                                                                          FriendsProfileScreen
                                                                              .routeName,
                                                                          arguments: {
                                                                            'image_url':
                                                                                womenList[halfI2]['member_image_url'],
                                                                            'username':
                                                                                womenList[halfI2]['membername'],
                                                                            'uid':
                                                                                womenList[halfI2]['memberId'],
                                                                          });
                                                                    },
                                                                    child: Text(
                                                                        '프로필')),
                                                              ],
                                                            ),
                                                            behavior:
                                                                HitTestBehavior
                                                                    .opaque, //background만 눌러서 모델 닫히게 하기
                                                          );
                                                        },
                                                      );
                                              },
                                              child: FadeInImage(
                                                placeholder: AssetImage(
                                                    'assets/images/person.png'),
                                                image: NetworkImage(
                                                    womenList[halfI2]
                                                        ['member_image_url']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            footer: creatorId ==
                                                    womenList[halfI2]
                                                        ['memberId']
                                                ? GridTileBar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            221, 88, 84, 84),
                                                    title: Center(
                                                      child: Text(
                                                          '${womenList[halfI2]['membername']}(방장)'),
                                                    ))
                                                : GridTileBar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            221, 88, 84, 84),
                                                    title: Center(
                                                      child: Text(
                                                          '${womenList[halfI2]['membername']}'),
                                                    )),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return isLeader
                                          ? ClipRRect(
                                              child: Container(
                                                color: Colors.red,
                                                child: GridTile(
                                                    child: IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            WaitingChannelAddScreen
                                                                .routeName,
                                                            arguments: {
                                                          'groupId': groupId,
                                                          'left-men-numbers':
                                                              membersNum / 2 -
                                                                  (userDocs
                                                                          as List)
                                                                      .where((e) =>
                                                                          e['member_gender'] ==
                                                                          '남자')
                                                                      .toList()
                                                                      .length,
                                                          'left-women-numbers':
                                                              membersNum / 2 -
                                                                  (userDocs
                                                                          as List)
                                                                      .where((e) =>
                                                                          e['member_gender'] ==
                                                                          '여자')
                                                                      .toList()
                                                                      .length
                                                        });
                                                  },
                                                )),
                                              ),
                                            )
                                          : ClipRRect(
                                              child: Container(
                                                  child: Text('여자'),
                                                  color: Colors.red),
                                            );
                                    }
                                  }
                                }),
                          ],
                        );
                      }),
                  // Expanded(child: WaitingMessages(currentUserId, groupId)),
                  // WaitingNewMessage(currentUserId, groupId),
                );
        });
  }
}
