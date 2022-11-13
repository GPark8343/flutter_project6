import 'package:flutter/material.dart';
import 'package:ifc_project1/dummy_data.dart';
import 'package:ifc_project1/providers/filter.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final filter = Provider.of<Filter>(context, listen: false);

    return Center(
        child: Column(
      children: [
        ElevatedButton(
            onPressed: () {
              filter.changeBar();
             
            },
            child: Text('bar')),
        ElevatedButton(
            onPressed: () {
              filter.changeRestaurant();
            },
            child: Text('restaurant')),
        ElevatedButton(
            onPressed: () {
              filter.changeCafe();
            },
            child: Text('cafe')),
      ],
    ));
  }
}
