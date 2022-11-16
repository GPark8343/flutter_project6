import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ifc_project1/providers/place/current_location.dart';
import 'package:ifc_project1/providers/place/filter.dart';
import 'package:ifc_project1/screens/place/place_detail_screen.dart';
import 'package:provider/provider.dart';

calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)) * 1000;
}

class PlaceListScreen extends StatefulWidget {
  @override
  State<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  @override
  Widget build(BuildContext context) {
    final current = Provider.of<CurrentLocation>(context, listen: false);
    var currentLocation = current.currentLocation;

    final filter = Provider.of<Filter>(context, listen: false);
    final filteredPlace = filter.PLACE;
    filteredPlace
        .sort((a, b) => (a["distance"] as num).compareTo(b["distance"] as num));

    return filteredPlace.length == 0
        ? Center(
            child: Text('filtering해주세여'),
          )
        : ListView.builder(
            itemCount: filteredPlace.length,
            itemBuilder: (context, index) {
              filteredPlace[index]['distance'] = calculateDistance(
                  (filteredPlace[index]['geometry'] as Map)['location']['lat'],
                  (filteredPlace[index]['geometry'] as Map)['location']['lng'],
                  currentLocation?.latitude ?? 0,
                  currentLocation?.longitude ?? 0);

              return ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(PlaceDetailScreen.routeName,
                        arguments: filteredPlace[index]["place_id"]);
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    backgroundImage: AssetImage(
                      './assets/images/${filteredPlace[index]['type']}.png',
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(filteredPlace[index]['name'].toString()),
                      RatingBarIndicator(
                        rating: 2.75,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 30.0,
                        direction: Axis.horizontal,
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '${filteredPlace[index]['distance'] as num > 10000 ? "???m" : (filteredPlace[index]['distance'] as num).toStringAsFixed(0)}m'),
                      Text('별점 개수')
                    ],
                  ));
            });
  }
}
