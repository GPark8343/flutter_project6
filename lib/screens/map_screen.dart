import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class MapScreen extends StatefulWidget {
  MapScreen();

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;
  List<Marker> _markers = [];

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

  Future<void> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat%2C$lng&radius=100&type=restaurant&key=AIzaSyA2xDDzNjtYm9Z5KG0EF8wzPLDOY1o3CNE');
    final response = await http.get(url);
    (json.decode(response.body)['results'] as List).forEach((element) {
      print(element['name']);
    });
  } //https://developers.google.com/maps/documentation/places/web-service/search-nearby 요거 참고['geometry']['location']['lat']

  void _sendPlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat%2C$lng&radius=50000&type=restaurant&key=AIzaSyA2xDDzNjtYm9Z5KG0EF8wzPLDOY1o3CNE');
    final response = await http.get(url);
    (json.decode(response.body)['results'] as List).forEach((place) async {
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId(place['place_id']),
            draggable: false,
            onTap: () => print(place['name']),
            position: LatLng(place['geometry']['location']['lat'],
                place['geometry']['location']['lng'])));
      });
   
      // try {
      //   await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(FirebaseAuth.instance.currentUser?.uid)
      //       .collection('place-list')
      //       .doc('')
      //       .delete();
      // } catch(e) {
      //   print(e);
      // }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('place-list')
          .add({
        'name': place['name'],
        'distance': calculateDistance(
                currentLocation!.latitude!,
                currentLocation!.longitude!,
                place['geometry']['location']['lat'],
                place['geometry']['location']['lng'])
            .toStringAsFixed(2),
        'latitude': place['geometry']['location']['lat'],
        'longitude': place['geometry']['location']['lng']
      });
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  // void addMarker() {setState(() {
  //   _markers.add(Marker(
  //       markerId: MarkerId("1"),
  //       draggable: true,
  //       onTap: () => print("Marker!"),
  //       position: LatLng( 37.5851446,127.029714)));
  // });

  // }

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
        onPressed: () {
          _goToTheCurrentLoc;
          getPlaceAddress(
              currentLocation!.latitude!, currentLocation!.longitude!);
          _sendPlace(currentLocation!.latitude!, currentLocation!.longitude!);
          // addMarker();
        },
        tooltip: 'refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
