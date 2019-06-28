import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSearch extends StatefulWidget {
  static const routeName = "/mapSearch";
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  @override
  _MapSearchState createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  final zoom = 10.0;

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    var currentLocation = <String, double>{};

    var location = new Location();

    try {
      currentLocation = await location.getLocation();

      print("current position found = ${currentLocation["latitude"]} / ${currentLocation["longitude"]}");

      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(currentLocation["latitude"], currentLocation["longitude"]), zoom: zoom)));
    } catch (error) {
      currentLocation = null;
      print("Geolocation permission not granted");
    }

    _getAllMarkers();
  }

  Future<Set<Marker>> _getAllMarkers() async {
    /*
    final Set<Marker> markers = Set();
    final addresses = [
      "13 Passage Saint Sebastien, Paris 75011, France",
      "92 rue réaumur, Paris, France",
      "5 Passage Saint Sebastien, Paris 75011, France"
    ];

    for (var address in addresses) {
      List<Placemark> placeMarks = await Geolocator().toPlacemark(address);
      final first = placeMarks.first;
      print("found address = ${first.position.longitude.toString()}");
      markers.add(Marker(
        markerId: MarkerId(addresses.indexOf(address).toString()),
        position: LatLng(first.position.latitude, first.position.longitude),
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }

    setState(() {
      this._markers = markers;
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Maps Sample App'),
            backgroundColor: Colors.green[700],
          ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: MapSearch._center,
              zoom: zoom,
            ),
            markers: _markers,
          )),
    );
  }
}
