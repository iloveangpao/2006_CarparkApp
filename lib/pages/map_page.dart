import 'dart:async';
import '../classes/carpark.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import './searchPageCarparks.dart';
import 'package:http/http.dart' as http;
import './booking_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MapPage());
}

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Google Map",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: MapScreen());
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<carpark> _carpark = <carpark>[];
  final storage = FlutterSecureStorage();
  List<dynamic> favData = [];

  void fetchData() async {
    final token = await storage.read(key: "access_token");
    print("token Read: $token");
    final url = Uri.parse('http://20.187.121.122/favourite/me/');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final newresponse = response.body;
    print(newresponse);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        favData = jsonResponse;
      });
    } else {
      print("Error");
    }
  }

  Future<List<carpark>> fetchcarpark() async {
    final response = await http.get(Uri.parse('http://20.187.121.122/avail/'));

    var carparks = <carpark>[];

    if (response.statusCode == 200) {
      var carparksJson = json.decode(response.body);

      for (var carparkJson in carparksJson) {
        carparks.add(carpark.fromJson(carparkJson));
      }
      setState(() {
        _carparks =
            carparks; // Update the carparks list with the fetched carparks
      });
    }
    return carparks;
  }

  void createFav(String cpCode) async {
    final token = await storage.read(key: "access_token");
    print("token Read: $token");
    final favBody = {'cp_code': cpCode};
    final url1 = Uri.parse('http://20.187.121.122/favourite/?cp_code=$cpCode');
    final response = await http.post(url1,
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(favBody));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      //shows alert that favourite went through
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              title: Text('Favourited successfully'),
            );
          });
    } else if (response.statusCode == 422) {
      print("Validation Error");
    } else {
      print("Status Code error ${response.statusCode}");
    }
  }

  void _updateCarparks() async {
    var carparks = await fetchcarpark();
    fetchData();
    setState(() {
      _carparks = carparks;
    });
  }

  Set<Marker> _createMarkers() {
    return _carparks.map((carpark) {
      bool isFavouritecheck = favData
          .where((item) => item['cp_code'] == carpark.carparkNo)
          .isNotEmpty;

      BitmapDescriptor icon;
      var availableLots = int.parse(carpark.lotsAvailable);
      if (availableLots < 10) {
        // Assign red color to marker
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      } else if (availableLots > 10 && availableLots <= 20) {
        // Assign orange color to marker
        icon =
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      } else {
        // Assign yellow color to marker
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      }

      Widget markerWidget = Stack(
        children: [
          Icon(Icons.favorite_border_outlined,
              color: isFavouritecheck ? Colors.red : Colors.transparent),
          Icon(Icons.location_on, color: Colors.red),
        ],
      );
      return Marker(
        markerId: MarkerId(carpark.carparkNo),
        position: LatLng(carpark.latitude, carpark.longitude),
        icon: icon,
        infoWindow: InfoWindow(
          title: carpark.carparkNo,
          snippet: '${carpark.lotsAvailable} lots available',
          onTap: () {
            bool isFavourite = favData
                .where((item) => item['cp_code'] == carpark.carparkNo)
                .isNotEmpty;
            print(favData);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(carpark.carparkNo),
                  content: Text('${carpark.lotsAvailable} lots available '),
                  actions: <Widget>[
                    TextButton(
                      child:
                          Text(isFavourite ? 'Unfavorite' : 'Add to Favorites'),
                      onPressed: () {
                        if (isFavourite) {
                          print('lol');
                        } else {
                          createFav(carpark.carparkNo);
                        }
                      },
                    ),
                    TextButton(
                      child: Text('Book Now'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingPage(cpCode: carpark.carparkNo),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    }).toSet();
  }

  static final Marker _testmarker = Marker(
      markerId: MarkerId("_test"),
      infoWindow: InfoWindow(title: "testmarker"),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(1.31827878141546, 103.87742961097146));

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
    // fetchcarpark().then((carparks) {
    //   setState(() {
    //     _carparks = carparks;
    //   });
    // });
    _updateCarparks();
    _getCurrentLocation();
    Timer.periodic(Duration(seconds: 10), (Timer t) => _updateCarparks());
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.31827878141546, 103.87742961097146),
    zoom: 20.5,
  );

  late GoogleMapController _googleMapController;
  List<carpark> _carparks = [];

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: false,
            initialCameraPosition: _currentLocation == null
                ? _initialCameraPosition
                : CameraPosition(target: _currentLocation!, zoom: 15),
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _createMarkers(),
          ),
          Container(
            height: 50,
            width: double.infinity,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Text("<10 parking slot"),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Text("<20 parking slots"),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Text(">20 parking slot"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 20),
        child: FloatingActionButton(
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
      ),
    );
  }
}
