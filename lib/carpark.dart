class carpark {
  String carparkNo;
  List<Geometry> geometries;
  String lotsAvailable;
  String lotType;
  double latitude;
  double longitude;

  carpark({required this.carparkNo, required this.geometries, required this.lotsAvailable, required this.lotType, required this.latitude, required this.longitude});

  factory carpark.fromJson(Map<String, dynamic> json) {
    var coordinates = json['geometries'][0]['coordinates'];
    var coordinateList = coordinates.split(",");
    return carpark(
      carparkNo: json['carparkNo'],
      geometries: List<Geometry>.from(json['geometries'].map((x) => Geometry.fromJson(x))),
      lotsAvailable: json['lotsAvailable'],
      lotType: json['lotType'],
      latitude: double.parse(coordinateList[0]),
      longitude: double.parse(coordinateList[1]),
    );
  }

}


class Geometry {
  String coordinates;

  Geometry({required this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      coordinates: json['coordinates'],
    );
  }
}
