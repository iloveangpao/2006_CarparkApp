import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key, required this.rankFunction});
  final Function rankFunction;

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: Center(
        child: Column(children: [
          SizedBox(height: 20),
          Text(
            "Filter By:",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 3,
              minimumSize: Size(100, 40),
            ),
            onPressed: () {
              widget.rankFunction("Availability");
              Navigator.pop(context);
            },
            child: Text(
              "Availability",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 5),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                minimumSize: Size(100, 40),
              ),
              onPressed: () {
                //To change later for price
                widget.rankFunction("rate");
                Navigator.pop(context);
              },
              child: Text(
                "Price",
                style: TextStyle(
                  fontSize: 15,
                ),
              )),
        ]),
      ),
    );
  }
}
