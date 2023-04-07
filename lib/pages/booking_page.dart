import 'dart:convert';

import 'package:flutter/material.dart';

import '../classes/Parking.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BookingPage extends StatefulWidget {
  final String carparkNo;
  const BookingPage({Key? key, required this.carparkNo}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedLotId;
  ParkingLot? parkingLot;
  Future<ParkingLot> fetchParkingLot(String carparkNo) async {
    final response = await http.get(Uri.parse('http://20.187.121.122/carpark/'));
    if (response.statusCode == 200) {
      final List<dynamic> parkingLotsJson = json.decode(response.body);
      final parkingLots = parkingLotsJson.map((json) => ParkingLot.fromJson(json)).toList();
      final parkingLot = parkingLots.firstWhere((parkingLot) => parkingLot.cpCode == carparkNo);
      return parkingLot;
    } else {
      throw Exception('Failed to fetch parking lots');
    }
  }

  //show time picker
  DateTime? bookingTime; // declare a variable to store the selected time

// show time picker and store the selected time
  void _showTimePicker() async {
    final selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedTime != null) {
      setState(() {
        bookingTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, selectedTime.hour, selectedTime.minute);
      });
    }
  }

  void _submitBooking() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: "access_token");
    print("token Read: $token");
    print(bookingTime!.toIso8601String());

    if (bookingTime != null) {
      final bookingBody = {
        'start_time': bookingTime!.toIso8601String(), // use the selected time in the body
        'lot_id' : selectedLotId,
      };
      final response = await http.post(Uri.parse('http://20.187.121.122/booking/'),
          headers: <String, String>{
            'accept' : 'application/json',
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
      // handle case where no time is selected
      print('select time!');
    }

  }

  @override
  void initState() {
    super.initState();
    fetchParkingLot(widget.carparkNo)
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
                        items: parkingLot!.lots.map((lot) => DropdownMenuItem<String>(
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
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Make your Booking For Today",
                          style: TextStyle( fontSize: 15),
                        ),
                        Text(
                          dateStr,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                        ),
                        SizedBox(height:10,),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "This Booking System only allow you to book within 2 "
                                " hour before you arrive at the destination ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: _showTimePicker,
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Color(0xff737373),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(child: Text(
                                "Pick Your Timing",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 20),))
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        )
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
                        "Confirm Your Booking: ${widget.carparkNo} ${parkingLot!.name}",
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