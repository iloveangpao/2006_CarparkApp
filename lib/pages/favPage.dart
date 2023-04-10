import 'dart:io';

import './booking_page.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final searchController = TextEditingController();
  final storage = FlutterSecureStorage();
  List<dynamic> favData = [];

  void fetchData() async {
    final token = await storage.read(key: "access_token");
    print("token Read: $token");
    final url = Uri.parse('http://20.187.121.122/favourite/me/');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final newresponse = response.body;
    print(newresponse);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        favData = jsonResponse;
      });
    } else {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          children: [
            SizedBox(width: 45),
            Text(
              "Your Favourites",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.favorite,
              color: Colors.red,
            )
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(children: <Widget>[
        favData.isEmpty
            ? Center(
                child: Text(
                  "No Favourites added yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            : Expanded(
                child: ListView.builder(
                    itemCount: favData.length,
                    itemBuilder: (context, index) {
                      final data = favData[index];
                      String data_cpCode = data['cp_code'];
                      return ListTile(
                        title: Text("Carpark Code: $data_cpCode"),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BookingPage(cpCode: data_cpCode);
                          }));
                        },
                      );
                    })),
      ]),
    );
  }
}
