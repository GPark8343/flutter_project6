import 'package:flutter/material.dart';

class OpponentUserIds with ChangeNotifier {
 List opponentUserIds=[];

  void addOpponentUserIds(uid) {
    opponentUserIds.add(uid);

    notifyListeners();
  }
  void clearOpponentUserIds() {
    opponentUserIds.clear();
   
    notifyListeners();
  }
   void deleteOpponentUserIds(uid) {
    opponentUserIds.remove(uid);
 
    notifyListeners();
  }
}
