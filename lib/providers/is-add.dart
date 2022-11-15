import 'package:flutter/material.dart';

class IsAdd with ChangeNotifier {
  bool isAdd = false;

  void changeIsAdd() {
    isAdd = !isAdd;
    notifyListeners();
  }
}
