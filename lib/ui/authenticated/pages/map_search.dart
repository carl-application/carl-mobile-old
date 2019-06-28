import 'dart:async';

import 'package:carl/ui/authenticated/business_search_delegate.dart';
import 'package:carl/ui/shared/rounded_icon.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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

      print(
          "current position found = ${currentLocation["latitude"]} / ${currentLocation["longitude"]}");

      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentLocation["latitude"], currentLocation["longitude"]), zoom: zoom)));
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

  void _showSearch() {
    showSearch(context: context, delegate: BusinessSearchDelegate());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
        color: CarlTheme.of(context).background,
        child: SafeArea(
            child: Column(
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: Container(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      RoundedIcon(
                        assetIcon: "assets/back.png",
                        onClick: () => Navigator.pop(context),
                        iconSize: 10,
                        padding: 10,
                        backgroundColor: Color.fromRGBO(142, 142, 147, .2),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => _showSearch(),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                color: Color.fromRGBO(142, 142, 147, .2)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: false,
                                  hintText: "Recherche",
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(142, 142, 147, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: MapSearch._center,
                  zoom: zoom,
                ),
                markers: _markers,
              ),
            )
          ],
        )),
      )),
    );
  }
}
