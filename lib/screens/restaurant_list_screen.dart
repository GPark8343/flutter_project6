import 'package:flutter/material.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('여기에 식당 리스트 올꺼임'),);
  }
}
// 아래처럼 ListView.builder 활용하고 위젯 여러개로 구분한 뒤, firebase에서 데이터 올리고 받아옴
// ListView.builder(
//           reverse: true,
//           itemCount: chatDocs?.length,
//           itemBuilder: (context, index) => MessageBubble(
//             chatDocs?[index]['text'],
//             FirebaseAuth.instance.currentUser?.uid ==
//                 chatDocs?[index]['userId'],
//             chatDocs?[index]['username'],
//              chatDocs?[index]['userImage'],
//             key: ValueKey(chatDocs?[index].id),
//           ),
//         );
//       },