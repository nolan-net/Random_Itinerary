import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

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
    body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(39.7285, -121.8375), // Set the initial position of the map to Chico
              zoom: 12.0, // Set the initial zoom level
            ),
            markers: markers,
          ),
          Positioned(
            right: 16.0,
            bottom: 1.0,
            top: MediaQuery.of(context).size.height / 2 - 50.0,
            child: FloatingActionButton(
              onPressed: _addMarker,
              child: Icon(Icons.add_location),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker() async {
    if (mapController == null) return;

    final LatLng? centerLatLng = await mapController?.getLatLng(ScreenCoordinate(
      x: (MediaQuery.of(context).size.width / 2).floor(),
      y: (MediaQuery.of(context).size.height / 2).floor(),
    ));

    if (centerLatLng != null) {
      final marker = Marker(
        markerId: MarkerId(DateTime.now().toString()),
        position: centerLatLng,
      );
      setState(() {
        markers.add(marker);
      });
    }
  }
}

