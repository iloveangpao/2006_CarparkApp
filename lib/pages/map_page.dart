import '../classes/carpark.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './booking_page.dart';



void main(){
  runApp(MapPage());
}

class MapPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Google Map",
        debugShowCheckedModeBanner: false,
        theme:ThemeData(
          primaryColor: Colors.white,
        ),
        home:MapScreen()
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<carpark> _carpark = <carpark>[];

  Future<List<carpark>> fetchcarpark() async {
    final response = await http.get(Uri.parse('http://20.187.121.122/avail/'));

    var carparks = <carpark>[];

    if (response.statusCode == 200) {

      var carparksJson = json.decode(response.body);

      for (var carparkJson in carparksJson) {
        carparks.add(carpark.fromJson(carparkJson));
      }
      setState(() {
        _carparks = carparks; // Update the carparks list with the fetched carparks
      });
    }
    return carparks;
  }

  Set<Marker> _createMarkers() {
    return _carparks.map((carpark) {
      print("Hello");
      print(carpark.latitude);// print statement here
      return Marker(
        markerId: MarkerId(carpark.carparkNo),
        position: LatLng(carpark.latitude,carpark.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: carpark.carparkNo,
          snippet: '${carpark.lotsAvailable} lots available',
        ),
        onTap: () {
          // Navigate to the booking page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingPage()),
          );
        },
      );
    }).toSet();
  }



  static final Marker _testmarker = Marker(
      markerId: MarkerId("_test"),
      infoWindow: InfoWindow(title: "testmarker"),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(1.31827878141546,103.87742961097146)
  );

  LatLng? _currentLocation;

  void _getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }


  @override
  void initState() {
    super.initState();
    fetchcarpark().then((carparks) {
      setState(() {
        _carparks = carparks;
      });
    });
    _getCurrentLocation();
  }


  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.31827878141546,103.87742961097146),
    zoom: 20.5,
  );

  late GoogleMapController _googleMapController;
  List<carpark> _carparks = [];

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          myLocationButtonEnabled: false,
          zoomGesturesEnabled: false,
          initialCameraPosition: _currentLocation == null
              ? _initialCameraPosition
              : CameraPosition(target: _currentLocation!, zoom: 15),
          onMapCreated: (controller) => _googleMapController = controller,
          markers: _createMarkers()
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () {
          if (_currentLocation != null) {
            _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: _currentLocation!, zoom: 15),
              ),
            );
          }
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
