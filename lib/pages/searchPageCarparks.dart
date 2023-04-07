import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'rankingPage.dart';
import 'dart:io';
import 'bookingSpecificPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

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
  final storage = FlutterSecureStorage();

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

  void createFav(String cpCode) async {
    final token = await storage.read(key: "access_token");
    print("token Read: $token");
    final favBody = {'cp_code': cpCode};
    final url1 = Uri.parse('http://20.187.121.122/favourite/?cp_code=$cpCode');
    final response = await http.post(url1,
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(favBody));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      //shows alert that favourite went through
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              title: Text('Favourited successfully'),
            );
          });
    } else if (response.statusCode == 422) {
      print("Validation Error");
    } else {
      print("Status Code error ${response.statusCode}");
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
                      String data_name = data['name'];
                      String data_cpCode = data['cp_code'];
                      print(data_avail.runtimeType);
                      if (data_avail == null) {
                        data_avail = 'No data for';
                      }
                      return ListTile(
                        title: Text("$data_name ($data_cpCode)"),
                        subtitle: Text("Rate: \$" +
                            data['rate'].toString() +
                            "/hr\n" +
                            "Availability: $data_avail lots"),
                        trailing: ElevatedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Favourite"),
                              Icon(Icons.favorite_border_outlined)
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF40000)),
                          onPressed: () {
                            createFav(data_cpCode);
                          },
                        ),
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
