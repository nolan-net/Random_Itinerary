import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:math';

import 'storage.dart';

class MapPage extends StatefulWidget {
  final String email;

  const MapPage({required this.email, Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String _selectedTypes = '';
  final storage = UserStorage();
  String location = 'Search Location';
  GoogleMapController? mapController;
  String apiKey = 'AIzaSyDILNkPpI7wpfSx1oRSqzbDPwzd6eCXVDE';
  //Don't need this now
  //  LatLng startLocation = const LatLng(39.7285, -121.8375);

  LatLng startLocation = LatLng(0, 0); // Initial value

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  void _initCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    setState(() {
      startLocation = LatLng(position.latitude, position.longitude);
    });
  }

  CameraPosition? cameraPosition;
  final Set<Marker> markers = new Set(); //markers for google map
  double _radius = 0; // 0 miles (in degrees)
  final TextEditingController _countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomGesturesEnabled: true, //allows users to zoom in and out with touch
            initialCameraPosition: CameraPosition(
              target: startLocation, // Set the initial position of the map to Chico
              zoom: 12.0, // Set the initial zoom level
            ),
            markers: markers,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
          ),
          Positioned(
            //search input bar
            top: 10,
            child: InkWell(
              onTap: () async {
                // Your previous onTap code here
              },
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      title: Text(
                        location,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.search),
                      dense: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Radius: ${(_radius * 60).toStringAsFixed(0)} miles'),
                    Slider(
                      value: _radius,
                      onChanged: (double value) {
                        setState(() {
                          _radius = value;
                        });
                      },
                      min: 0,
                      max: 50 / 60, // 50 miles to degrees
                      divisions: 50,
                                          label: '${(_radius * 60).toStringAsFixed(0)} miles',
                    ),
                    FilterDropdown(
                      onFilterChanged: (selectedFilters) {
                        setState(() {
                          _selectedTypes = selectedFilters.join('|');
                        });
                      },
                    ),
                    TextField(
                      controller: _countController,
                      decoration: InputDecoration(labelText: 'Count'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addRandomMarkers(int.parse(_countController.text));
          // Dismiss the keyboard
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _addRandomMarkers(int count) async {
    final double centerLatitude = 39.7285;
    final double centerLongitude = -121.8375;
    final Random random = Random();
    setState(() {
      markers.clear();
    });

    final plist = GoogleMapsPlaces(
      apiKey: apiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    for (int i = 0; i < count; i++) {
      final result = await plist.searchNearbyWithRadius(
        Location(lat: centerLatitude, lng: centerLongitude),
        (_radius * 1609).toInt(), // Convert miles to degrees
        type: _selectedTypes,
      );

      if (result.status == 'OK' && result.results.isNotEmpty) {
        int randomIndex = random.nextInt(result.results.length);
        PlacesSearchResult randomPlace = result.results[randomIndex];
        LatLng randomLatLng = LatLng(randomPlace.geometry!.location.lat, randomPlace.geometry!.location.lng);

        // Check if the location is already marked, if so, continue to the next iteration
        if (markers.any((marker) => marker.position == randomLatLng)) {
          i--;
          continue;
        }

        // Move the camera to the random location
        mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: randomLatLng, zoom: 17)));

        // Add a marker at the random location
        setState(() {
          markers.add(Marker(
            markerId: MarkerId(randomLatLng.toString()),
            position: randomLatLng,
            infoWindow: InfoWindow(
              title: randomPlace.name!,
              snippet: randomPlace.vicinity,
              onTap:() {
                storage.writeUserBookmark(widget.email, randomPlace.placeId, randomPlace.name,randomPlace.vicinity);
              }
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No nearby places found within the specified radius.')),
        );
      }
    }
  }
}

class FilterDropdown extends StatefulWidget {
  final Function(List<String> selectedFilters) onFilterChanged;

  const FilterDropdown({required this.onFilterChanged, Key? key}) : super(key: key);

  @override
  _FilterDropdownState createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  List<String> _filters = [
    'restaurant',
    'park',
    'movie_theater',
    'cafe',
    'casino',
    'pet_store',
    'clothing_store',
    'gym',
    'university',
    'zoo',
    'store',
  ];
  List<String> _selectedFilters = [];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text('Select filters'),
      onChanged: (String? newValue) {
        setState(() {
                    if (newValue != null) {
            _selectedFilters.contains(newValue)
                ? _selectedFilters.remove(newValue)
                : _selectedFilters.add(newValue);
            widget.onFilterChanged(_selectedFilters);
          }
        });
      },
      items: _filters.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(value),
            value: _selectedFilters.contains(value),
            onChanged: (bool? selected) {
            setState(() {
                if (selected == true) {
                  _selectedFilters.add(value);
                } else {
                  _selectedFilters.remove(value);
                }
                widget.onFilterChanged(_selectedFilters);
              });
            },
          ),
        );
      }).toList(),
    );
  }
}