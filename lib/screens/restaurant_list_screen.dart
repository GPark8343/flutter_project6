import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ifc_project1/DUMMY_DATA.dart';
import 'package:ifc_project1/providers/current_location.dart';
import 'package:ifc_project1/providers/filter.dart';
import 'package:location/location.dart';
import 'dart:core';

import 'package:provider/provider.dart';

calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)) * 1000;
}

class RestaurantListScreen extends StatefulWidget {
  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  @override
  Widget build(BuildContext context) {
    final current = Provider.of<CurrentLocation>(context, listen: false);
    var currentLocation = current.currentLocation;

    final filter = Provider.of<Filter>(context, listen: false);
    final filteredPlace = filter.PLACE;

    return ListView.builder(
        itemCount: filteredPlace.length,
        itemBuilder: (context, index) {
          filteredPlace.sort(
              (a, b) => (a["distance"] as num).compareTo(b["distance"] as num));
          filteredPlace[index]['distance'] = calculateDistance(
              (filteredPlace[index]['geometry'] as Map)['location']['lat'],
              (filteredPlace[index]['geometry'] as Map)['location']['lng'],
              currentLocation?.latitude ?? 0,
              currentLocation?.longitude ?? 0);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              backgroundImage:  AssetImage(
                          './assets/images/${filteredPlace[index]['type']}.png',
                        ),
            ),
            title: Text(filteredPlace[index]['name'].toString()),
            subtitle: Text(
                '${(filteredPlace[index]['distance'] as num).toStringAsFixed(0)}m'),
          );
        });
  }
}
