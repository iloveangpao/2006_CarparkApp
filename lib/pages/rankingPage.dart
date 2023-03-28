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
          Text(
            "Rank By:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
              onPressed: () {
                widget.rankFunction("Availability");
                Navigator.pop(context);
              },
              child: Text("Availability")),
          ElevatedButton(
              onPressed: () {
                //To change later for price
                widget.rankFunction("name");
                Navigator.pop(context);
              },
              child: Text("Price")),
        ]),
      ),
    );
  }
}
