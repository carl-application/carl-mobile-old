import 'dart:async';

import 'package:carl/data/repository_dealer.dart';
import 'package:carl/models/business/business_card.dart';
import 'package:carl/translations.dart';
import 'package:carl/ui/authenticated/pages/map_marker_detail.dart';
import 'package:carl/ui/authenticated/pages/search.dart';
import 'package:carl/ui/shared/rounded_icon.dart';
import 'package:carl/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSearch extends StatefulWidget {
  static const routeName = "/mapSearch";
  static const LatLng _center = const LatLng(48.866667, 2.333333);

  @override
  _MapSearchState createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  final zoom = 15.0;

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    var currentLocation = <String, double>{};

    var location = new Location();

    try {
      currentLocation = await location.getLocation();
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentLocation["latitude"], currentLocation["longitude"]), zoom: zoom)));
    } catch (error) {
      currentLocation = null;
    }

    _getAllMarkers();
  }

  _showDetail(BusinessCard business) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15), topRight: Radius.circular(15))),
              child: MapMarkerDetail(business: business,)
            ),
          );
        });
  }

  void _getAllMarkers() async {
    final repository = RepositoryDealer.of(context).userRepository;
    final businesses = await repository.getBusinessesLocations();

    final Set<Marker> markers = Set();

    businesses.forEach((business) {
      markers.add(Marker(
        markerId: MarkerId(business.id.toString()),
        position: LatLng(business.latitude, business.longitude),
        onTap: () => _showDetail(business)
      ));
    });

    setState(() {
      this._markers = markers;
    });
  }

  void _showSearch() {
    Navigator.of(context).pushNamed(Search.routeName);
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
                        backgroundColor: CarlTheme.of(context).searchGreyColor,
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
                                color: CarlTheme.of(context).searchGreyColor),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  filled: false,
                                  hintText: Translations.of(context).text("search_label"),
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
