import 'package:flutter/material.dart';



class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  //show time picker
  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now());
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
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(child: Text(
                        "Confirm Your Booking",
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
