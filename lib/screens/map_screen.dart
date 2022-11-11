import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/place.dart';

class MapScreen extends StatefulWidget {


  MapScreen();

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  GoogleMapController? _mapController;
  Location? _location = Location();
  LocationData? currentLocation;


  
 
  Future<void> _getCurrentUserLocation2() async {
    try {
      final locData = await Location().getLocation();
      setState(() {
         currentLocation = locData;
      });
    } catch (error) {
      return;
    }
  }

  

  void _onMapCreated(GoogleMapController _cntrl) {
    _mapController = _cntrl;
    _location?.onLocationChanged.listen((l) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 17),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserLocation2();
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
              // markers: (_pickedLocation == null && widget.isSelecting)
              //     ? {}
              //     : {
              //         Marker(
              //             markerId: MarkerId('m1'),
              //             position: _pickedLocation ??
              //                 LatLng(currentLocation!.latitude!,
              //                     currentLocation!.longitude!))
              //       },
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentUserLocation2,
        tooltip: 'refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
