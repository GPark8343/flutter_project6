import 'package:flutter/material.dart';

class Rating with ChangeNotifier {
  double userRating = 4;

  void submitData(context, ratingController) {
    if (ratingController.text.isEmpty) {
      return;
    }

    final enteredAmount = double.parse(ratingController.text);

    if (enteredAmount < 0 || enteredAmount > 5) {
      return; // 조건문 만족하면 다음 함수 멈추기
    }
    userRating = enteredAmount;
    print(userRating);
    Navigator.of(context).pop();
    notifyListeners();
  }
}
