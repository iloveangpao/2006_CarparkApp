import '../pages/chatPage.dart';
import '../pages/favPage.dart';
import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/booking_page.dart';
import 'pages/searchPage.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      title: 'Carparking App',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(textTheme).copyWith(
          bodyMedium: GoogleFonts.sourceSansPro(),
        ),
        sliderTheme: SliderThemeData(
            valueIndicatorColor: Colors.white,
            valueIndicatorTextStyle: TextStyle(color: Colors.black)),
        primaryColor: Color(0xFFD6F1FF),
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFD6F1FF),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            titleTextStyle: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
