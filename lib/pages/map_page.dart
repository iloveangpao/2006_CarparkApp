import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator_platform_interface/src/enums/location_permission.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'currentBooking.dart';
import './booking_page.dart';
import './chatPage.dart';
import './favPage.dart';
import './SearchPageArea.dart';

// void main() => runApp(MaterialApp(
//       home: MapSample(),
//     ));

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: Colors.blue[900],
//           unselectedItemColor: Colors.white,
//           type: BottomNavigationBarType.fixed,
//           unselectedLabelStyle:
//               const TextStyle(color: Colors.white, fontSize: 14),
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home, color: Colors.white),
//               label: 'Search',
//             ),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.search, color: Colors.white),
//                 label: 'Bookings'),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.heart_broken_rounded, color: Colors.white),
//                 label: 'Favourites'),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.phone_in_talk, color: Colors.white),
//                 label: 'Settings'),
//           ]),
//     );
//   }
// }

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  int _selectedIndex = 0;
  final screens = [
    SearchPageArea(),
    currentBookingPage(),
    FavPage(),
    ChatPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _initialPosition = CameraPosition(target: LatLng(0, 0));

  Future<LatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  static const CameraPosition _woodlandsmrt = CameraPosition(
    target: LatLng(1.4368967, 103.78658),
    zoom: 14.4746,
  );

  static const CameraPosition _marsiling = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(1.43239, 103.7741167),
      zoom: 14);

  static final Marker _marsilingmarker = Marker(
    markerId: MarkerId("_kGooglePlexMarker"),
    infoWindow: InfoWindow(title: "Marker"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(1.43239, 103.7741167),
  );

  static Marker _woodlandsmrtmarker = Marker(
    markerId: MarkerId("_kSecondMarker"),
    infoWindow: InfoWindow(title: "Second"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    position: LatLng(1.4368967, 103.78658),
  );

  //static const LatLng source =

  List<LatLng> polyLineCoordinates = [];

  void getPolyPoints() async {
    String googleApiKey = "AIzaSyCOsATiiB_VhRpYdmUHhnkf48BcfokDJ-s";
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(_marsiling.target.latitude, _marsiling.target.longitude),
        PointLatLng(
            _woodlandsmrt.target.latitude, _woodlandsmrt.target.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polyLineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {_woodlandsmrtmarker, _marsilingmarker},
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polyLineCoordinates,
          )
        },
        initialCameraPosition: _marsiling,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLoc,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.my_location,
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> _goToCurrentLoc() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng userLocation = LatLng(position.latitude, position.longitude);
    Marker updatedMarker = _woodlandsmrtmarker.copyWith(
      positionParam: userLocation,
    );

    setState(() {
      _woodlandsmrtmarker = updatedMarker;
      print(_woodlandsmrtmarker.position);
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
