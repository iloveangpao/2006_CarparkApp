import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'searchPageCarparks.dart';

class SearchPageArea extends StatefulWidget {
  const SearchPageArea({super.key});

  @override
  State<SearchPageArea> createState() => _SearchPageAreaState();
}

class _SearchPageAreaState extends State<SearchPageArea> {
  final searchController = TextEditingController();
  double x_coord = 0;
  double y_coord = 0;

  List<dynamic> searchData = [];

  Future<void> _fetchData() async {
    final query = searchController.text;
    final url = Uri.parse('http://20.187.121.122/search/$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        searchData = jsonResponse;
      });
    } else {
      print("ERROR");
    }
  }

  void _handleSearch() async {
    await _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Search",
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(0xffc6c6c6),
              width: 0.40,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x3f000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          //padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(8),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                    icon: Icon(Icons.search), onPressed: _handleSearch),
                hintText: 'Search an area',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: searchData.length,
                itemBuilder: (context, index) {
                  final data = searchData[index];
                  return ListTile(
                    title: Text(data['SEARCHVAL']),
                    subtitle: Text(data['ADDRESS']),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SearchPageCarparks(
                            x_coords: data['X'], y_coords: data['Y']);
                      }));
                    },
                    // leading: Image.network(
                    //   carpark.imageUrl,
                    //   fit: BoxFit.cover,
                    //   width: 100,
                    //   height: 100,
                    // ),
                    // title: Text(carpark.typeOfCarpark + " Carpark"),
                    // subtitle: Text(carpark.address +
                    //     "\n" +
                    //     "${carpark.availableLots}/500 lots\n" +
                    //     "${carpark.distInKm} km away                  " +
                    //     "\$${carpark.pricePerHours}/hr"),
                    // isThreeLine: true,
                  );
                })),
      ]),
    );
  }
}
