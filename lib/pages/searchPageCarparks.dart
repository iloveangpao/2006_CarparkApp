import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'rankingPage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'bookingSpecificPage.dart';

class SearchPageCarparks extends StatefulWidget {
  const SearchPageCarparks(
      {super.key, required this.x_coords, required this.y_coords});

  final String x_coords;
  final String y_coords;

  @override
  State<SearchPageCarparks> createState() => _SearchPageCarparksState();
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.toString() + "    this is path");

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.txt');
}

Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0
    return 0;
  }
}

Future<File> writeCounter(var jsonVals) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsString('tf lol');
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
    var url;
    if (rankType == 'rate') {
      //only for price rates rank low to high
      url = Uri.parse(
          'http://20.187.121.122/nearbyCP/${widget.x_coords},${widget.y_coords}/$rankType/F');
    } else {
      url = Uri.parse(
          'http://20.187.121.122/nearbyCP/${widget.x_coords},${widget.y_coords}/$rankType/T');
    }

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
                      var data_avail = data['Availability'];
                      print(data_avail.runtimeType);
                      if (data_avail == null) {
                        data_avail = 'No data for';
                      }
                      return ListTile(
                        title: Text(data['name']),
                        subtitle: Text("Rate: \$" +
                            data['rate'].toString() +
                            "/hr\n" +
                            "Availability: $data_avail lots"),
                        onTap: () {
                          print(data.toString());
                          print(
                              "X:" + widget.x_coords + "Y: " + widget.y_coords);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BookingSpecificPage(
                              carparkName: data['name'],
                              lots: data['lots'],
                            );
                          }));
                        },
                      );
                    })),
      ]),
    );
  }
}
