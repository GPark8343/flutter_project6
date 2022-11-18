
import 'package:flutter/material.dart';
import 'package:ifc_project1/widgets/chat/chat_people_drawer.dart';
import 'package:ifc_project1/widgets/chat/messages.dart';
import 'package:ifc_project1/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat';
  @override
  Widget build(BuildContext context) {
    final currentUserId =
        (ModalRoute.of(context)?.settings.arguments as Map)['currentUserId'];
  
    final groupId =
        (ModalRoute.of(context)?.settings.arguments as Map)['groupId'];
    return Scaffold(
      endDrawer: ChatPeopleDrawer(groupId),
      appBar: AppBar(
        title: const Text('FlutterChat'),
        // actions: [
        //   DropdownButton(
        //       underline: Container(),
        //       icon: Icon(
        //         Icons.more_vert,
        //         color: Theme.of(context).primaryIconTheme.color,
        //       ),
        //       items: [
        //         DropdownMenuItem(
        //           child: Container(
        //             child: Row(
        //               children: [
        //                 Icon(Icons.exit_to_app),
        //                 SizedBox(
        //                   width: 8,
        //                 ),
        //                const Text('Logout')
        //               ],
        //             ),
        //           ),
        //           value: 'logout',
        //         ),
        //       ],
        //       onChanged: (itemIdentifier) {
        //         if (itemIdentifier == 'logout') {
        //           FirebaseAuth.instance.signOut();
        //         }
        //       })
        // ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Messages(currentUserId,  groupId)),
            NewMessage(currentUserId, groupId),
//             IconButton(
//                 onPressed: () async {
//                   var data = await FirebaseFirestore.instance
//                       .collection("users")
//                       .doc(FirebaseAuth.instance.currentUser?.uid)
//                       .collection('groupinfo')
//                       .where("oppoIds", isEqualTo: [
//                         'QTh5zmfZUiaNv9OxywSSPBvVMTy1',
//                       ])
//                       .snapshots()
//                       .first;
//                   var isData = await FirebaseFirestore.instance
//                       .collection("users")
//                       .doc(FirebaseAuth.instance.currentUser?.uid)
//                       .collection('groupinfo')
//                       .where("oppoIds", isEqualTo: [
//                         'QTh5zmfZUiaNv9OxywSSPBvVMTy1',
//                       ])
//                       .snapshots()
//                       .isEmpty;
// if(isData){
//  var result = data.docs[0].data()["oppoIds"];
//                   print(result);
// }else{
//    print('읎다');
// }
                 
//                 },
//                 icon: Icon(Icons.abc))
          ],
        ),
      ),
    );
  }
}
