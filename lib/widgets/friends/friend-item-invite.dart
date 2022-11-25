import 'package:flutter/material.dart';

import 'package:ifc_project1/providers/chat/all_ids.dart';
import 'package:ifc_project1/providers/chat/all_ids_invite.dart';
import 'package:provider/provider.dart';

class FriendItemInvite extends StatefulWidget {
  final bool addScreen;
  final String name;
  final String imageUrl;
  final String uid;
  const FriendItemInvite(this.name, this.imageUrl, this.uid,
      {this.addScreen = false, super.key});

  @override
  State<FriendItemInvite> createState() => _FriendItemInviteState();
}

class _FriendItemInviteState extends State<FriendItemInvite> {
  var isSelected = false;
  @override
  Widget build(BuildContext context) {
    var userIds = Provider.of<AllIdsInvite>(context, listen: false);
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        if (isSelected) {
          userIds.addAllId(widget.uid);
        }else{
           userIds.deleteAllId(widget.uid);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
            title: Text(
              widget.name,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.imageUrl,
              ),
              radius: 30,
            ),
            trailing: isSelected ? Icon(Icons.circle,color: Colors.yellow,) : Icon(Icons.circle)),
      ),
    );
  }
}
