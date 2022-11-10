import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen(
      {this.initialLocation =
          const PlaceLocation(latitude: 37.586345, longitude: 127.029383),
      this.isSelecting = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  double? currentLatitude = 37.586345;
  double? currentLongitude = 127.029383;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();

        currentLatitude = locData.latitude;
        currentLongitude = locData.longitude;

    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getCurrentUserLocation(),
          builder: (ctx, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLatitude!, currentLongitude!),
                      zoom: 17,
                    ),
                    onTap: widget.isSelecting ? _selectLocation : null,
                    markers: (_pickedLocation == null && widget.isSelecting)
                        ? {}
                        : {
                            Marker(
                                markerId: MarkerId('m1'),
                                position: _pickedLocation ??
                                    LatLng(currentLatitude!, currentLongitude!))
                          },
                  );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentUserLocation,
        tooltip: 'refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
