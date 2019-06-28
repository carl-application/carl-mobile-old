import 'dart:async';

import 'package:carl/ui/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/models/placemark.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/models/location_accuracy.dart';
import 'package:geolocator/models/position.dart';

class MapSearch extends StatelessWidget {
  static const routeName = "/mapSearch";
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final zoom = 10.0;

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    Position position = await Geolocator().getPosition(LocationAccuracy.high);
    print("current position found = ${position.latitude} / ${position.longitude}");

    /*
    controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(first.position.latitude, first.position.longitude), zoom: zoom)
        ));
    */
  }

  Future<Set<Marker>> _getAllMarkers() async {
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

    print("returning list with ${markers.length} markers");
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: FutureBuilder<Set<Marker>>(
          future: _getAllMarkers(),
          builder: (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Press button to start.');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: Loader(),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final markers = snapshot.data;
                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: zoom,
                    ),
                    markers: markers,
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
