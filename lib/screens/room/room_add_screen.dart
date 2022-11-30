import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ifc_project1/providers/chat/waiting_channel_making.dart';

import 'package:ifc_project1/screens/room/waiting_room_screen.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RoomAddScreen extends StatefulWidget {
  const RoomAddScreen({super.key});
  static const routeName = '/room-add';

  @override
  State<RoomAddScreen> createState() => _RoomAddScreenState();
}

enum RoomNumber { NONE, TWO, FOUR, SIX, EIGHT, TEN }

RoomNumber _roomNumber = RoomNumber.NONE;

class _RoomAddScreenState extends State<RoomAddScreen> {
  var isLoading = false;

  final _formKey = GlobalKey<FormState>();
  var _description = '';
  var _membersNum;
  var _title = '';

  void submitFn(String groupId) async {
    final waitingChannelMaking =
        Provider.of<WaitingChannelMaking>(context, listen: false);

    await waitingChannelMaking.waitingAddChannel(
        (FirebaseAuth.instance.currentUser?.uid as String),
        [],
        groupId,
        _membersNum,
        _title,
        _description);
  }

  void goto(String groupId, BuildContext context) {
    Navigator.of(context)
        .pushReplacementNamed(WaitingRoomScreen.routeName, arguments: {
      'currentUserId': FirebaseAuth.instance.currentUser?.uid,
      'groupId': groupId,
      'membersNum': _membersNum
    });
  }

  @override
  void initState() {
    setState(() {
      _membersNum = 0;
      _roomNumber = RoomNumber.NONE;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _trySubmit() {
      final isValid = _formKey.currentState?.validate();
      FocusScope.of(context).unfocus();

      if (isValid!) {
        _formKey.currentState?.save();
        final groupId = Uuid().v1();
        submitFn(groupId);
        goto(groupId, context);
      }
    }

    return Scaffold(
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
          title: Text('방만들기'),
          actions: isLoading
              ? []
              : [
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (_membersNum != 0) _trySubmit();
                      setState(() {
                        isLoading = false;
                      });
                    },
                    icon: Icon(Icons.add),
                  )
                ],
        ),
        body: Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                            key: ValueKey('number 2'),
                            title: Text('1대1'),
                            value: RoomNumber.TWO,
                            groupValue: _roomNumber,
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  _membersNum = value == RoomNumber.NONE
                                      ? 0
                                      : value == RoomNumber.TWO
                                          ? 2
                                          : value == RoomNumber.FOUR
                                              ? 4
                                              : value == RoomNumber.SIX
                                                  ? 6
                                                  : value == RoomNumber.EIGHT
                                                      ? 8
                                                      : 10;
                                }
                                _roomNumber = value as RoomNumber;
                              });
                              print(_membersNum);
                            }),
                        RadioListTile(
                            key: ValueKey('number 4'),
                            title: Text('2대2'),
                            value: RoomNumber.FOUR,
                            groupValue: _roomNumber,
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  _membersNum = value == RoomNumber.NONE
                                      ? 0
                                      : value == RoomNumber.TWO
                                          ? 2
                                          : value == RoomNumber.FOUR
                                              ? 4
                                              : value == RoomNumber.SIX
                                                  ? 6
                                                  : value == RoomNumber.EIGHT
                                                      ? 8
                                                      : 10;
                                }
                                _roomNumber = value as RoomNumber;
                              });
                            }),
                        RadioListTile(
                            key: ValueKey('number 6'),
                            title: Text('3대3'),
                            value: RoomNumber.SIX,
                            groupValue: _roomNumber,
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  _membersNum = value == RoomNumber.NONE
                                      ? 0
                                      : value == RoomNumber.TWO
                                          ? 2
                                          : value == RoomNumber.FOUR
                                              ? 4
                                              : value == RoomNumber.SIX
                                                  ? 6
                                                  : value == RoomNumber.EIGHT
                                                      ? 8
                                                      : 10;
                                }
                                _roomNumber = value as RoomNumber;
                              });
                            }),
                        RadioListTile(
                            key: ValueKey('number 8'),
                            title: Text('4대4'),
                            value: RoomNumber.EIGHT,
                            groupValue: _roomNumber,
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  _membersNum = value == RoomNumber.NONE
                                      ? 0
                                      : value == RoomNumber.TWO
                                          ? 2
                                          : value == RoomNumber.FOUR
                                              ? 4
                                              : value == RoomNumber.SIX
                                                  ? 6
                                                  : value == RoomNumber.EIGHT
                                                      ? 8
                                                      : 10;
                                }
                                _roomNumber = value as RoomNumber;
                              });
                            }),
                        RadioListTile(
                            key: ValueKey('number 10'),
                            title: Text('5대5'),
                            value: RoomNumber.TEN,
                            groupValue: _roomNumber,
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  _membersNum = value == RoomNumber.NONE
                                      ? 0
                                      : value == RoomNumber.TWO
                                          ? 2
                                          : value == RoomNumber.FOUR
                                              ? 4
                                              : value == RoomNumber.SIX
                                                  ? 6
                                                  : value == RoomNumber.EIGHT
                                                      ? 8
                                                      : 10;
                                }
                                _roomNumber = value as RoomNumber;
                              });
                            }),
                        TextFormField(
                          key: ValueKey('title'),
                          autocorrect: true,
                          textCapitalization: TextCapitalization.words,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 4) {
                              return 'Please enter at least 4 characters.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'title'),
                          onSaved: (value) {
                            _title = value as String;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          key: ValueKey('description'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a description.';
                            }
                            if (value.length < 10) {
                              return 'Should be  at least 10 characters long.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Description'),
                          onSaved: (value) {
                            _description = value as String;
                          },
                        )
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}
