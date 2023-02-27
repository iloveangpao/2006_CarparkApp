import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MaterialApp(
  home: MapSample(),
));



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[900],
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 14),
        items: const [

          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.white),
              label: 'Search',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.white),
              label: 'Bookings'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.heart_broken_rounded, color: Colors.white),
              label: 'Favourites'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.phone_in_talk, color: Colors.white),
              label: 'Settings'
          ),

        ]
      ),
    );
  }
}




class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  static final Marker _KGooglePlexMarker = Marker(
      markerId: MarkerId("_kGooglePlexMarker"),
      infoWindow: InfoWindow(title: "Marker"),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(37.42796133580664, -122.085749655962),
  );

  static  Marker _kSecondMarker = Marker(
    markerId: MarkerId("_kSecondMarker"),
    infoWindow: InfoWindow(title: "Second"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    position: LatLng(37.43296265331129, -122.08832357078792),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {
          _kSecondMarker,
          _KGooglePlexMarker
        },
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue[900],
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 14),
          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.white),
              label: 'Search',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.white),
                label: 'Bookings'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.heart_broken_rounded, color: Colors.white),
                label: 'Favourites'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.phone_in_talk, color: Colors.white),
                label: 'Settings'
            ),

          ]
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng userLocation = LatLng(position.latitude, position.longitude);
    Marker updatedMarker = _kSecondMarker.copyWith(
      positionParam: userLocation,
    );
    setState(() {
      _kSecondMarker = updatedMarker;
    });
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLocation,
          zoom: 14.0,
        ),
      ),
    );
  }

}


