import 'dart:math';

import 'package:flutter/material.dart';

class BookingSpecificPage extends StatefulWidget {
  BookingSpecificPage(
      {super.key, required this.carparkName, required this.lots});

  List<dynamic> lots;
  String carparkName;

  @override
  State<BookingSpecificPage> createState() => _BookingSpecificPageState();
}

class _BookingSpecificPageState extends State<BookingSpecificPage> {
  String? _selectedTime;
  int? _selectedLot;
  //show time picker

  Future<void> _selectTime() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _selectedTime = result.format(context);
      });
    }
  }

  void _selectLot(int lotId) {
    setState(() {
      _selectedLot = lotId;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String dateStr = "${today.day}-${today.month}-${today.year}";

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(title: Text("Booking"), leading: BackButton()),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Please Make your Booking For Today",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            dateStr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 45),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: _selectTime,
                            child: Container(
                                padding: const EdgeInsets.all(20),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                    child: Text(
                                  "Pick Your Timing",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _selectedTime != null
                                ? ("Time Selected: $_selectedTime")
                                : 'No time selected',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Carpark: ${widget.carparkName}",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            _selectedLot != null
                                ? ("Lot Selected: $_selectedLot")
                                : 'No lot selected',
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 20),
                          for (int i = 0; i < widget.lots.length; i++)
                            ElevatedButton(
                                onPressed: () {
                                  _selectLot(widget.lots[i]['id']);
                                },
                                child: Text("Lot ${widget.lots[i]['id']}")),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Text(
                          "Confirm Your Booking",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ))),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
