import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:ifc_project1/providers/current_location.dart';
import 'package:ifc_project1/providers/filter.dart';


import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  MapScreen();

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> _markers = [];
  CollectionReference placeList = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('place-list');


  void _sendPlace() async {
  if(this.mounted){  final filter = Provider.of<Filter>(context, listen: false);
    final filteredPlace = filter.PLACE;
    setState(() {
      
    });
    (filteredPlace).forEach((place) {
      
        setState(() {
          _markers.add(Marker(
              markerId: MarkerId(place['place_id']),
              draggable: false,
              onTap: () => print(place['name']),
              position: LatLng(place['geometry']['location']['lat'],
                  place['geometry']['location']['lng'])));
        });
      
    });}
  }

  @override
  Widget build(BuildContext context) {
    final current = Provider.of<CurrentLocation>(context, listen: false);

    var currentLocation = current.currentLocation;

    return Scaffold(
      body: currentLocation == null
          ? Center(
              child: TextButton(
                  child: Text("find the current location"),
                  onPressed: () async {
                    await current.getCurrentUserLocation();
         
                    _sendPlace();
                  }),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
                zoom: 17,
              ),
              markers: Set.from(_markers),

              // markers: (_pickedLocation == null && widget.isSelecting)
              //     ? {}
              //     : {
              //         Marker(
              //             markerId: MarkerId('m1'),
              //             position: _pickedLocation ??
              //                 LatLng(currentLocation!.latitude!,
              //                     currentLocation!.longitude!))
              //       },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await current.getCurrentUserLocation();

          _sendPlace();
          // addMarker();
        },
        tooltip: 'refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
