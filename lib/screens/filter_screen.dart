import 'package:flutter/material.dart';

class FilterScreen extends StatelessWidget {
  bool isBar;
  bool isRestaurant;
  bool isCafe;

  FilterScreen({ this.isBar = false, this.isRestaurant = true, this.isCafe = false});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ElevatedButton(onPressed: () {}, child: Text('bar')),
        ElevatedButton(onPressed: () {}, child: Text('restaurant')),
        ElevatedButton(onPressed: () {}, child: Text('cafe')),
      ],
    ));
  }
}
