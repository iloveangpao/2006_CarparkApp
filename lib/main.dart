import 'package:flutter/material.dart';

import './searchPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carparking App',
      theme: ThemeData(
        sliderTheme: SliderThemeData(
            valueIndicatorColor: Colors.white,
            valueIndicatorTextStyle: TextStyle(color: Colors.black)),
        primaryColor: Color(0xFFD6F1FF),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFD6F1FF),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carparking App'),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SearchPage();
          }));
        },
        child: Text("Search"),
      )),
    );
  }
}
