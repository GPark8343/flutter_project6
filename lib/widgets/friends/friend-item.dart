import 'package:flutter/material.dart';
import 'package:ifc_project1/providers/all_ids.dart';
import 'package:provider/provider.dart';

class FriendItem extends StatefulWidget {
  final bool addScreen;
  final String name;
  final String imageUrl;
  final String uid;
  const FriendItem(this.name, this.imageUrl, this.uid,
      {this.addScreen = false, super.key});

  @override
  State<FriendItem> createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  var isSelected = false;
  @override
  Widget build(BuildContext context) {
    var opponentUserIds = Provider.of<AllIds>(context, listen: false);
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        if (isSelected) {
          opponentUserIds.addAllId(widget.uid);
        }else{
           opponentUserIds.deleteAllId(widget.uid);
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
