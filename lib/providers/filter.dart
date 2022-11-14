import 'package:flutter/cupertino.dart';
import 'package:ifc_project1/dummy_data.dart';

class Filter with ChangeNotifier {
  var isBar = false;
  var isRestaurant = false;
  var isCafe = false;
  List PLACE = [];

  void changeBar() {
    PLACE = DUMMY_PLACES.where((e) => e["type"] == "bar").toList();

    notifyListeners();
  }

  void changeRestaurant() {
    PLACE = DUMMY_PLACES.where((e) => e["type"] == "restaurant").toList();

    notifyListeners();
  }

  void changeCafe() {
    PLACE = DUMMY_PLACES.where((e) => e["type"] == "cafe").toList();

    notifyListeners();
  }
   Map findById(id) {   

    return DUMMY_PLACES.firstWhere((place) => place['place_id'] == id);

  }
}
