import 'dart:async';

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
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
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}


