import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ifc_project1/DUMMY_DATA.dart';
import 'package:ifc_project1/providers/filter.dart';
import 'package:location/location.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  MapScreen();

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;
  List<Marker> _markers = [];
  CollectionReference placeList = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('place-list');



  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      setState(() {
        currentLocation = locData;
      });
    } catch (error) {
      return;
    }
  }

  late CameraPosition _currentLoc = CameraPosition(
      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      zoom: 17);

  Future<void> _goToTheCurrentLoc() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentLoc));
  }

  Future<void> getPlaceAddressPrint() async {
   
    final filter = Provider.of<Filter>(context, listen: false);
    print(filter.PLACE);
  } //https://developers.google.com/maps/documentation/places/web-service/search-nearby 요거 참고['geometry']['location']['lat']

  void _sendPlace() async {
          final filter = Provider.of<Filter>(context, listen: false);
          final filteredPlace = filter.PLACE;
    (filteredPlace).forEach((place) {
      if (this.mounted) {
        setState(() {
          _markers.add(Marker(
              markerId: MarkerId(place['place_id']),
              draggable: false,
              onTap: () => print(place['name']),
              position: LatLng(place['geometry']['location']['lat'],
                  place['geometry']['location']['lng'])));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
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
          _goToTheCurrentLoc;
          await getPlaceAddressPrint();
          _sendPlace();
          // addMarker();
        },
        tooltip: 'refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
