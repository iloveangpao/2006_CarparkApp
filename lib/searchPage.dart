import 'package:flutter/material.dart';

import './carparks.dart';
import 'filterPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();

  //list of carparks, imported from carparks.dart
  List<Carpark> displayedCarparkList = carparkList;

  void searchAddress(String query) {
    final searchResults = carparkList.where((carpark) {
      return carpark.address.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      displayedCarparkList = searchResults;
    });
  }

  void _applyFilters(int aMin, int aMax, double distMin, double distMax,
      double priceMin, double priceMax) {
    // apply the filters here
    List<Carpark> filteredCarparkList = carparkList.where((carpark) {
      return carpark.availableLots >= aMin &&
          carpark.availableLots <= aMax &&
          carpark.distInKm >= distMin &&
          carpark.distInKm <= distMax &&
          carpark.pricePerHours >= priceMin &&
          carpark.pricePerHours <= priceMax;
    }).toList();

    setState(() {
      displayedCarparkList = filteredCarparkList;
    });
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
          style: TextStyle(color: Colors.black),
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
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                    icon: Icon(Icons.tune),
                    onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return FilterPage(setFilters: _applyFilters);
                        }))),
                hintText: 'Search an address',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                )),
            onChanged: searchAddress,
          ),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: displayedCarparkList.length,
                itemBuilder: (context, index) {
                  final Carpark carpark = displayedCarparkList[index];
                  return ListTile(
                    leading: Image.network(
                      carpark.imageUrl,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                    title: Text(carpark.typeOfCarpark + " Carpark"),
                    subtitle: Text(carpark.address +
                        "\n" +
                        "${carpark.availableLots}/500 lots\n" +
                        "${carpark.distInKm} km away                  " +
                        "\$${carpark.pricePerHours}/hr"),
                    isThreeLine: true,
                  );
                }))
      ]),
    );
  }
}
