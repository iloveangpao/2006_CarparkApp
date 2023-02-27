import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final Function setFilters;

  const FilterPage({super.key, required this.setFilters});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double _availabilityStart = 0;
  double _availabilityEnd = 500;
  double _distanceStart = 0;
  double _distanceEnd = 10;
  double _priceStart = 0;
  double _priceEnd = 6;

  //Range slider building function
  Widget _buildRangeSlider(
      String titleVal,
      double startVal,
      double endVal,
      double minV,
      double maxV,
      int div,
      RangeLabels rangeLab,
      void Function(RangeValues) updateVal) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleVal,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          RangeSlider(
              values: RangeValues(startVal, endVal),
              min: minV,
              max: maxV,
              divisions: div,
              activeColor: Color(0xFF7F56D9),
              labels: rangeLab,
              onChanged: updateVal),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          _buildRangeSlider(
            "Availability",
            _availabilityStart,
            _availabilityEnd,
            0,
            500,
            100,
            RangeLabels(
              _availabilityStart.round().toString(),
              _availabilityEnd.round().toString(),
            ),
            (values) {
              setState(() {
                _availabilityStart = values.start;
                _availabilityEnd = values.end;
              });
            },
          ),
          _buildRangeSlider(
            "Distance",
            _distanceStart,
            _distanceEnd,
            0,
            10,
            100,
            RangeLabels(
              _distanceStart.toStringAsFixed(1),
              _distanceEnd.toStringAsFixed(1),
            ),
            (values) {
              setState(() {
                _distanceStart = values.start;
                _distanceEnd = values.end;
              });
            },
          ),
          _buildRangeSlider(
            "Price",
            _priceStart,
            _priceEnd,
            0,
            6,
            12,
            RangeLabels(
              '\$${_priceStart.toStringAsFixed(2)}/hr',
              '\$${_priceEnd.toStringAsFixed(2)}/hr',
            ),
            (values) {
              setState(() {
                _priceStart = values.start;
                _priceEnd = values.end;
              });
            },
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.setFilters(
                      _availabilityStart.toInt(),
                      _availabilityEnd.toInt(),
                      _distanceStart,
                      _distanceEnd,
                      _priceStart,
                      _priceEnd);
                  Navigator.pop(context);
                },
                child: Text('Apply Filter'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
