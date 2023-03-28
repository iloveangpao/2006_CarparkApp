import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'rankingPage.dart';

class SearchPageCarparks extends StatefulWidget {
  const SearchPageCarparks(
      {super.key, required this.x_coords, required this.y_coords});

  final String x_coords;
  final String y_coords;

  @override
  State<SearchPageCarparks> createState() => _SearchPageCarparksState();
}

class _SearchPageCarparksState extends State<SearchPageCarparks> {
  final searchController = TextEditingController();
  bool _isLoading = false;

//nearbyCP/X,Y/asdsad
  List<dynamic> searchData = [];

  Future<void> _fetchDataInit() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'http://20.187.121.122/nearbyCP/${widget.x_coords},${widget.y_coords}/id/T');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        searchData = jsonResponse;
        _isLoading = false;
      });
    } else {
      print("ERROR");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchDataRanking(String rankType) async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'http://20.187.121.122/nearbyCP/${widget.x_coords},${widget.y_coords}/$rankType/T');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        searchData = jsonResponse;
        _isLoading = false;
      });
    } else {
      print("ERROR");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDataInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Search Results",
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Carparks within 500m of your searched area:",
                style: TextStyle(fontSize: 16)),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RankingPage(rankFunction: _fetchDataRanking);
                }));
              },
              icon: Icon(Icons.tune),
            ),
          ],
        ),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
                child: ListView.builder(
                    itemCount: searchData.length,
                    itemBuilder: (context, index) {
                      final data = searchData[index];
                      return ListTile(
                        title: Text(data['name']),
                        subtitle: Text("Rate: " +
                            data['Rates']['weekdayRate'].toString() +
                            "/hr\n" +
                            "Availability: ${data['Availability']} lots"),
                      );
                    })),
      ]),
    );
  }
}
