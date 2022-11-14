import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class CurrentLocation with ChangeNotifier {
  LocationData? currentLocation;

  Future<void> getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();

      currentLocation = locData;
      notifyListeners();
    } catch (error) {
      return;
    }
  }
}
