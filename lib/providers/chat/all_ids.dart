import 'package:flutter/material.dart';

class AllIds with ChangeNotifier {
 List idsList=[];

  void addAllId(uid) {
   idsList.add(uid);
    idsList.sort();
    notifyListeners();
  }
  void clearaddAllIds() {
    idsList.clear();
      idsList.sort();
    notifyListeners();
  }
   void deleteAllId(uid) {
   idsList.remove(uid);
 
    notifyListeners();
  }
}
