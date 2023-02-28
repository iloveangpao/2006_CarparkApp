import 'package:carparkapp/pages/chatPage.dart';
import 'package:carparkapp/pages/favPage.dart';
import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/booking_page.dart';
import 'pages/searchPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String buttonName = "Click";
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
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
      home: LoginPage(),
    );
  }
}
