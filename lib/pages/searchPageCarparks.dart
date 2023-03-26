import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'http://20.187.121.122/nearbyCP/${widget.x_coords},${widget.y_coords}/asd');
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
    _fetchData();
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
        Text("List of carparks within 5 min of your selected area:"),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
                child: ListView.builder(
                    itemCount: searchData.length,
                    itemBuilder: (context, index) {
                      final data = searchData[index];
                      return ListTile(
                        title: Text(data['name']),
                        subtitle: Text(
                            "Rate: " + data['Rates']['weekdayRate'] + "/hr"),
                      );
                    })),
      ]),
    );
  }
}
