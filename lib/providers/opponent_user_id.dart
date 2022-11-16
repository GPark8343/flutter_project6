import 'package:flutter/material.dart';

class OpponentUserId with ChangeNotifier {
  var opponentUserId;

  void changeOpponentUserId(uid) {
    opponentUserId = uid;
    notifyListeners();
  }
}
