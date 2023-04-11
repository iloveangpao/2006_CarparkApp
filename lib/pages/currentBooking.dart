import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../classes/Parking.dart';
import '../classes/curbooking.dart';

class currentBookingPage extends StatefulWidget {
  const currentBookingPage({Key? key}) : super(key: key);

  @override
  State<currentBookingPage> createState() => _currentBookingPage();
}

class _currentBookingPage extends State<currentBookingPage> {
  List<BookingInfo> bookings = [];

  // show time picker
  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  void _getBooking() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: "access_token");
    print("token Read: $token");
    // print(bookingStartTime!.toIso8601String());
    // print(bookingEndTime!.toIso8601String()); // print the end time

    // check if both start and end time are set

    final response = await http.get(
      Uri.parse('http://20.187.121.122/booking/me/'),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      bookings = data.map((json) => BookingInfo.fromJson(json)).toList();
      print("success!");
      print('Lot ID: ${bookings.first.lotId}');
      setState(() {});
    } else {
      // handle error
      print(response.body);
    }
  }

  void _removeBooking() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: "access_token");
    // print("token Read: $token");
    // print(bookingStartTime!.toIso8601String());
    // print(bookingEndTime!.toIso8601String()); // print the end time
    print(bookings.first.id);
    // check if both start and end time are set
    final response = await http.delete(Uri.parse('http://20.187.121.122/booking/${bookings.first.id}'),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
    if (response.statusCode == 200) {
      // handle success
      print("success!");
    } else {
      // handle error
      print(response.body);
    }

  }

  @override
  void initState() {
    _getBooking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Booking"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Color(0xFFD6F1FF),
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : /* Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Capark: ${bookings.first.name}',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Lot Booked: ${bookings.first.lotId}',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 8),
            Text(
              'Lot Booked: ${bookings.first.cpCode}',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            Text(
              'Time of Booking: ${bookings.first.startTime}',
              style: const TextStyle(fontSize: 30),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _removeBooking,
              child: Text("Remove Booking"),
            ),
          ],
        ),
      ),*/
          Column(children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "${bookings.first.name}",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Carpark Code: ${bookings.first.cpCode}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Booked Lot ID",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${bookings.first.lotId}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Time of Booking",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${DateFormat('dd-MM-yyyy HH:mm').format(bookings.first.startTime)}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Price paid",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "\$${bookings.first.rate} per ${bookings.first.min}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
    );
  }
}
