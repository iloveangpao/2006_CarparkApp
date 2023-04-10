import 'dart:convert';

import 'package:flutter/material.dart';

import '../classes/Parking.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingPage extends StatefulWidget {
  final String cpCode;
  const BookingPage({Key? key, required this.cpCode}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedLotId;
  ParkingLot? parkingLot;
  Future<ParkingLot?> fetchParkingLot(String cpCode) async {
    final response = await http.get(Uri.parse('http://20.187.121.122/carpark/'));
    if (response.statusCode == 200) {
      final List<dynamic> parkingLotsJson = json.decode(response.body);
      final parkingLots = parkingLotsJson.map((json) => ParkingLot.fromJson(json)).toList();
      final parkingLot = parkingLots?.firstWhere((parkingLot) => parkingLot.cpCode == cpCode);
      return parkingLot;
    } else {
      throw Exception('Failed to fetch parking lots');
    }
  }

  //show time picker
  DateTime? bookingStartTime; // add new variable for start time
  DateTime? bookingEndTime; // declare a variable to store the selected time

// show time picker and store the selected time
  void _showTimePicker() async {
    final selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedTime != null) {
      setState(() {
        if (bookingStartTime == null || bookingEndTime == null) {
          // set the start time if it has not been set
          bookingStartTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, selectedTime.hour, selectedTime.minute);
        } else {
          // set the end time if the start time has been set
          bookingEndTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, selectedTime.hour, selectedTime.minute);
        }
      });
    }
  }

  void _showEndTimePicker() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        // store the selected end time in bookingEndTime variable
        bookingEndTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          selectedTime.hour,
          selectedTime.minute,
        );
      });
    }
  }

  void _submitBooking() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: "access_token");
    // print("token Read: $token");
    // print(bookingStartTime!.toIso8601String());
    // print(bookingEndTime!.toIso8601String()); // print the end time

    if (bookingStartTime != null && bookingEndTime != null) { // check if both start and end time are set
      final bookingBody = {
        'start_time': bookingStartTime!.toIso8601String(),
        'end_time': bookingEndTime!.toIso8601String(), // include the end time in the booking body
        'lot_id': selectedLotId,
      };
      final response = await http.post(Uri.parse('http://20.187.121.122/booking/'),
          headers: <String, String>{
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(bookingBody));
      if (response.statusCode == 200) {
        // handle success
        print("success!");
      } else {
        // handle error
        print(response.body);
      }
    } else {
      // handle case where either start or end time is not selected
      print('select start and end time!');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchParkingLot(widget.cpCode)
        .then((parkingLot) => setState(() => this.parkingLot = parkingLot))
        .catchError((error) => print(error));
  }



  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String dateStr = "${today.day}-${today.month}-${today.year}";
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(title: Text("CurrentBooking"),leading: BackButton()),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [

                if (parkingLot != null)
                  Column(
                    children: [
                      Text("Lots available:"),
                      DropdownButton<String>(
                        value: selectedLotId, // set the value of the dropdown to the selected lot id
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLotId = newValue!;
                          });
                        },
                        items: parkingLot!.lots.where((lot) => !lot['occupied']) .map((lot) => DropdownMenuItem<String>(
                          value: lot['id'].toString(),
                          child: Text(lot['id'].toString()),
                        )).toList(),
                      ),
                    ],
                  ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Please Make your Booking For Today",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _showTimePicker,
                          child: Text("Select Start Time"),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _showEndTimePicker, // new button to select end time
                          child: Text("Select End Time"),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _submitBooking,
                          child: Text("Submit Booking"),
                        ),
                      ],
                    ),

                  ),
                ),
                SizedBox(height:50),
                GestureDetector(
                  onTap: _submitBooking,
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(child: Text(
                        "Confirm Your Booking: ${widget.cpCode} ${parkingLot!.name}",
                        style: TextStyle(color: Colors.white,
                            fontSize: 20),))
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}