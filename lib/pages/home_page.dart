import 'package:carparkapp/pages/currentBooking.dart';
import 'package:flutter/material.dart';
import './booking_page.dart';
import './chatPage.dart';
import './favPage.dart';
import './map_page.dart';
import './SearchPageArea.dart';

//page that holds bottom nav bar
class HomePage extends StatefulWidget {
  final String email;

  HomePage({required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    SearchPageArea(),
    currentBookingPage(),
    MapPage(),
    FavPage(),
  ];
  int _selectedPageIndex = 2;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Color(0xFFD6DCFF),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Color(0xFF1ecbe1),
        // selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.description),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.location_on),
            label: "Map",
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.favorite),
            label: "Favourites",
          ),
        ],
      ),
    );
  }
}
