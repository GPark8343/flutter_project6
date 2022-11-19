import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WaitingNewMessage extends StatefulWidget {
  final String currentUserId;

  final String groupId;

  WaitingNewMessage(this.currentUserId, this.groupId);

  @override
  State<WaitingNewMessage> createState() => _WaitingNewMessageState();
}

class _WaitingNewMessageState extends State<WaitingNewMessage> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
        _controller.clear();
    final user =
        FirebaseAuth.instance.currentUser; // 지금은 currentuser가 Future이 아님
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    FirebaseFirestore.instance
        .collection('waiting-groups')
        .doc(widget.groupId)
        .collection('messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': userData['username'],
      'image_url': userData['image_url']
    });

  
      await FirebaseFirestore.instance
          .collection('waiting-groups')
          .doc(widget.groupId)
          .update({
        'last_message': _enteredMessage,
        'createdAt': Timestamp.now(),
      });



  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(labelText: 'Send a message...'),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
