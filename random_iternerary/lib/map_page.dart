import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'storage.dart';

class MapPage extends StatefulWidget {
  final String email;

  const MapPage({required this.email, Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final storage = UserStorage();
  String location = 'Search Location';
  GoogleMapController? mapController;
  String apiKey = 'AIzaSyDILNkPpI7wpfSx1oRSqzbDPwzd6eCXVDE';
  LatLng startLocation = const LatLng(39.7285, -121.8375);
  CameraPosition? cameraPosition;
  final Set<Marker> markers = new Set(); //markers for google map
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
            markers: getmarkers(),
            mapType: MapType.normal,
             onMapCreated: (controller) { //method called when map is created
                      setState(() {
                        mapController = controller; 
                      });
            },
          ),
             Positioned(  //search input bar
               top:10,
               child: InkWell(
                 onTap: () async {
                  var place = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: apiKey,
                          mode: Mode.overlay,
                          types: [],
                          strictbounds: false,
                          components: [],
                                      //google_map_webservice package
                          onError: (err){
                             print(err);
                          }
                      );

                   if(place != null){
                        setState(() {
                          location = place.description.toString();
                        });

                       //form google_maps_webservice package
                       final plist = GoogleMapsPlaces(apiKey:apiKey,
                              apiHeaders: await GoogleApiHeaders().getHeaders(),
                                        //from google_api_headers package
                        );
                        String placeid = place.placeId ?? "0";
                        final detail = await plist.getDetailsByPlaceId(placeid);
                        final geometry = detail.result.geometry!;
                        final lat = geometry.location.lat;
                        final lang = geometry.location.lng;
                        var newlatlang = LatLng(lat, lang);
                        
                       setState(() {
                        //move map camera to selected place with animation
                        markers.add(Marker( //add first marker
                        markerId: MarkerId(detail.toString()),
                        position: newlatlang, //position of marker
                        infoWindow: InfoWindow( //popup info 
                          title: 'Bookmark',
                          snippet: 'Tap the info box to save to bookmarks',
                          onTap: (){  
                            print("You Tapped me!");
                            //Here we save google place id, create firebase instance and then save to user
                            storage.writeUserBookmark(widget.email, placeid);
                          },
                        
                  

                        ),
                        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
                        ));
                       });
                        mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                   }
                 },
                 child: Padding(
                   padding: EdgeInsets.all(15),
                    child: Card(
                       child: Container(
                         padding: EdgeInsets.all(0),
                         width: MediaQuery.of(context).size.width - 40,
                         child: ListTile(
                            title:Text(location, style: TextStyle(fontSize: 18),),
                            trailing: Icon(Icons.search),
                            dense: true,
                         )
                       ),
                    ),
                 )
               ),
            ),
        ],
      ),
    );
  }
  Set<Marker> getmarkers() { //markers to place on map
    return markers;
  }

}

