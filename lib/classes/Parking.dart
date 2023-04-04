class ParkingLot {
  final String? id;
  final String cpCode;
  final String name;
  final Map<String, dynamic> locations;
  final double rate;
  final String min;
  final dynamic availability;
  final List<dynamic> lots;

  ParkingLot({
    this.id,
    required this.cpCode,
    required this.name,
    required this.locations,
    required this.rate,
    required this.min,
    this.availability,
    required this.lots,
  });

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      id: json['id'],
      cpCode: json['cp_code'],
      name: json['name'],
      locations: json['locations'],
      rate: json['rate'].toDouble(),
      min: json['min'],
      availability: json['Availability'],
      lots: json['lots'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cp_code'] = this.cpCode;
    data['name'] = this.name;
    data['locations'] = this.locations;
    data['rate'] = this.rate;
    data['min'] = this.min;
    data['Availability'] = this.availability;
    data['lots'] = this.lots;
    return data;
  }
}
