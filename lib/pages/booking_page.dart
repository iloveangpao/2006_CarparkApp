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
        backgroundColor: Colors.grey[300],
        appBar: AppBar(leading: BackButton()),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please Make your Booking For Today",
                  style: TextStyle( fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  dateStr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                ),
                SizedBox(height:50,),
                Text(
                  "This Booking System only allow you to book within 2 "
                      " hour before you arrive at the destination ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 100,
                ),
                MaterialButton(
                  onPressed: _showTimePicker,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Pick a timing',
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  ),
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 50,
                ),
            GestureDetector(
              child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(color: Colors.black,
                    borderRadius: BorderRadius.circular(8),),
                  child: Center(child: Text(
                    "Confirm Your Booking",
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),))
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
