import 'package:flutter/material.dart';


class FriendItem extends StatefulWidget {
  final bool addScreen;
  final String name;
  final String imageUrl;
  const FriendItem(this.name, this.imageUrl,
      {this.addScreen = false, super.key});

  @override
  State<FriendItem> createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
                title: Text(
                  widget.name.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.imageUrl.toString(),
                  ),
                  radius: 30,
                ),
                trailing: Icon(Icons.circle)),
          ),
        ),
        const Divider(indent: 85),
      ],
    );
  }
}
