import 'package:flutter/material.dart';

class ChannelMaking with ChangeNotifier {
  var isBar = false;
  var isRestaurant = false;
  var isCafe = false;
  List PLACE = [];

  void changeBar() {
    PLACE = [];

    notifyListeners();
  }
Future <void> addChannel(String currentUserId, List opponentsUserId) async{

}

Future <void> getChannel() async{

}

}
