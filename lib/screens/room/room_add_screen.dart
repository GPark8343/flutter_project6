import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ifc_project1/providers/chat/channel_making.dart';
import 'package:ifc_project1/providers/chat/waiting_channel_making.dart';
import 'package:ifc_project1/screens/chat/channel_add_screen.dart';
import 'package:ifc_project1/screens/room/waiting_room_screen.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RoomAddScreen extends StatefulWidget {
  const RoomAddScreen({super.key});
  static const routeName = '/room-add';

  @override
  State<RoomAddScreen> createState() => _RoomAddScreenState();
}

class _RoomAddScreenState extends State<RoomAddScreen> {
  var isLoading = false;

  final _formKey = GlobalKey<FormState>();

  var _membersNum;
  var _title = '';

  void submitFn(String groupId) async {
    final waitingChannelMaking =
        Provider.of<WaitingChannelMaking>(context, listen: false);

    await waitingChannelMaking.waitingAddChannel(
        (FirebaseAuth.instance.currentUser?.uid as String),
        [],
        groupId,
        int.parse(_membersNum),
        _title);
  }

  void goto(String groupId, BuildContext context) {
    Navigator.of(context)
        .pushReplacementNamed(WaitingRoomScreen.routeName, arguments: {
      'currentUserId': FirebaseAuth.instance.currentUser?.uid,
      'groupId': groupId,
      'membersNum': int.parse(_membersNum)
    });
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
        appBar: AppBar(
          title: Text('방만들기'),
          actions: isLoading
              ? []
              : [
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      _trySubmit();
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
                        TextFormField(
                          key: ValueKey('members number'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          enableSuggestions: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid number.';
                            } else if (num.parse(value).runtimeType != int) {
                              return 'Please enter an int.';
                            } else if (int.parse(value) <= 1 ||
                                int.parse(value) > 10) {
                              return 'Please enter a valid number between 2~10.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(labelText: 'number of members'),
                          onSaved: (value) {
                            _membersNum = value;
                          },
                        ),
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
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}
