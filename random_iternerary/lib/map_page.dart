import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  final String email;
  const MapPage({required this.email, Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(39.7285, -121.8375), // Set the initial position of the map to Chico
          zoom: 12.0, // Set the initial zoom level
        ),
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _searchForPlaces,
        child: Icon(Icons.search),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _searchForPlaces() async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurant&location=39.7285,-121.8375&radius=2000&region=us&type=restaurant,cafe,bakery&key=AIzaSyDILNkPpI7wpfSx1oRSqzbDPwzd6eCXVDE'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['status'] == 'OK') {
        final results = json['results'];

        for (final result in results) {
          final marker = Marker(
            markerId: MarkerId(result['place_id']),
            position: LatLng(
              result['geometry']['location']['lat'],
              result['geometry']['location']['lng'],
            ),
            infoWindow: InfoWindow(title: result['name'], snippet: result['formatted_address'],
            onTap: (){},),
          );

          setState(() {
            markers.add(marker);
          });
        }
      }
    }
  }
}

