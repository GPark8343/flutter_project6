import 'package:flutter/material.dart';
import 'package:ifc_project1/screens/chat_screen.dart';

import '../info.dart';

class ChannelListScreen extends StatelessWidget {
  const ChannelListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: info.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ChatScreen.routeName,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      info[index]['name'].toString(),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        info[index]['message'].toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        info[index]['profilePic'].toString(),
                      ),
                      radius: 30,
                    ),
                    trailing: Text(
                      info[index]['time'].toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(indent: 85),
            ],
          );
        },
      ),
    );
  }
}
