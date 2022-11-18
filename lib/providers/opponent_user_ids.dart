import 'package:flutter/material.dart';

class OpponentUserIds with ChangeNotifier {
 List opponentUserIds=[];

  void addOpponentUserIds(uid) {
    opponentUserIds.add(uid);
    opponentUserIds.sort();
    notifyListeners();
  }
  void clearOpponentUserIds() {
    opponentUserIds.clear();
       opponentUserIds.sort();
    notifyListeners();
  }
   void deleteOpponentUserIds(uid) {
    opponentUserIds.remove(uid);
 
    notifyListeners();
  }
}
