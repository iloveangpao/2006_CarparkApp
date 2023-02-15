import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
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


