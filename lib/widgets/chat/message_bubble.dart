import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/colors.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userName;
  final String userImage;

  MessageBubble(this.message, this.isMe, this.userName, this.userImage,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMe
        ? Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 45,
              ),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: messageColor,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 30,
                        top: 5,
                        bottom: 20,
                      ),
                      child: Column(
                        children: [
                          Text(
                            message,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Row(
          children: [CircleAvatar(
                    backgroundImage: NetworkImage(userImage),
                  ),
            Column( crossAxisAlignment: CrossAxisAlignment.start,
              children: [  Padding(
                        padding: const EdgeInsets.only(left: 12.5),
                        child: Text(
                          userName,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 45,
                      ),
                      child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: senderMessageColor,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 30,
                                        top: 5,
                                        bottom: 20,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            message,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                    ),
                  ),
              ],
            ),
          ],
        );
  }
}





// Stack(
//       children: [
//         Row(
//           mainAxisAlignment:
//               isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   color: isMe ? messageColor : senderMessageColor,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(12),
//                       topRight: Radius.circular(12),
//                       bottomLeft:
//                           !isMe ? Radius.circular(0) : Radius.circular(12),
//                       bottomRight:
//                           isMe ? Radius.circular(0) : Radius.circular(12))),
//               width: 140,
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//               margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//               child: Column(
//                 crossAxisAlignment:
//                     isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                 children: isMe
//                     ? [
//                         Text(
//                           message,
//                           style: TextStyle(color: Colors.white),
//                           textAlign: isMe ? TextAlign.end : TextAlign.start,
//                         ),
//                       ]
//                     : [
//                         Text(
//                           userName,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, color: Colors.white),
//                         ),
//                         Text(
//                           message,
//                           style: TextStyle(color: Colors.white),
//                           textAlign: isMe ? TextAlign.end : TextAlign.start,
//                         ),
//                       ],
//               ),
//             ),
//           ],
//         ),
//        isMe? Container(): Positioned(
//             top: 0,
//             left: isMe ? null : 120,
//             right: isMe ? 120 : null,
//             child: CircleAvatar(
//               backgroundImage: NetworkImage(userImage),
//             )),
//       ],
//       clipBehavior: Clip.none,
//     );