import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Google Map",
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        primaryColor: Colors.white,
      ),
      home:Scaffold()
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.388034525243647, 103.90178979616115),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;

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
        initialCameraPosition:_initialCameraPosition ,
        onMapCreated: (controller) => _googleMapController = controller,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition)
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
