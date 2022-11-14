import 'package:flutter/cupertino.dart';
import 'package:ifc_project1/dummy_data.dart';

class Filter with ChangeNotifier {
  var isBar = false;
  var isRestaurant = false;
  var isCafe = false;
  List PLACE = DUMMY_PLACES;

  void changeBar() {
    PLACE = DUMMY_PLACES.where((e) => e["type"] == "bar").toList();
    var isBar = true;
    var isRestaurant = false;
    var isCafe = false;
    notifyListeners();
  }

  void changeRestaurant() {
    PLACE = DUMMY_PLACES.where((e) => e["type"] == "restaurant").toList();
    var isBar = false;
    var isRestaurant = true;
    var isCafe = false;
    notifyListeners();
  }

  void changeCafe() {
    PLACE = DUMMY_PLACES.where((e) => e["type"] == "cafe").toList();
    var isBar = false;
    var isRestaurant = false;
    var isCafe = true;
    notifyListeners();
  }
}
