import 'package:flutter/material.dart';
import 'package:ifc_project1/helper/location_helper.dart';
import 'package:ifc_project1/providers/filter.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatefulWidget {
  static const routeName = '/place-detail';

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments;
    final selectedPlaces = Provider.of<Filter>(context).findById(id);
    String? _previewImageUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlaces['name']),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.asset(
              './assets/images/${selectedPlaces['type']}.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            selectedPlaces["geometry"]['address'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 170,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey)),
              child: Image.network(
                LocationHelper.generateLocationPreviewImage(
                    latitude: selectedPlaces['geometry']['location']['lat'],
                    longitude: selectedPlaces['geometry']['location']['lng']),
                fit: BoxFit.cover,
                width: double.infinity,
              )),
          
        ],
      ),
    );
  }
}
