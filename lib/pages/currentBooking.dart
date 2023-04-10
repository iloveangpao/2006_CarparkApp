import 'dart:convert';

import 'package:flutter/material.dart';

import '../classes/Parking.dart';
import '../classes/curbooking.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class currentBookingPage extends StatefulWidget {
  const currentBookingPage({Key? key}) : super(key: key);

  @override
  State<currentBookingPage> createState() => _currentBookingPage();
}

class _currentBookingPage extends State<currentBookingPage> {
  List<BookingInfo> bookings = [];

  //show time picker
  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  void _submitBooking() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: "access_token");
    print("token Read: $token");
    // print(bookingStartTime!.toIso8601String());
    // print(bookingEndTime!.toIso8601String()); // print the end time

  // check if both start and end time are set

    final response = await http.get(Uri.parse('http://20.187.121.122/booking/me'),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      bookings = data
          .map((json) => BookingInfo.fromJson(json))
          .toList();
      print("success!");
      print('Lot ID: ${bookings.first.lotId}');
      setState(() {});

    }
 else {
      // handle error
      print(response.body);
    }
  }

  @override
  void initState() {
    _submitBooking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Booking"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Roadside Carpark',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '267 Pasir Ris Dr, Singapore 678912',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Lot Booked: ${bookings.first.lotId}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Time of Booking: ${bookings.first.startTime}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Duration booked: ${bookings.first.min} hour(s)',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Price paid:/hr',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}