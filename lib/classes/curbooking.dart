class BookingInfo {
  final int id;
  final int userId;
  final DateTime startTime;
  final DateTime endTime;
  final int lotId;
  final String carparkId;
  final List<double> location;
  final String min;
  final String cpCode;
  final String name;
  final double rate;

  BookingInfo({
    required this.id,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.lotId,
    required this.carparkId,
    required this.location,
    required this.min,
    required this.cpCode,
    required this.name,
    required this.rate,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    final bookingJson = json['booking'];
    final carparkJson = json['carpark'];

    return BookingInfo(
      id: bookingJson['id'],
      userId: bookingJson['user_id'],
      startTime: DateTime.parse(bookingJson['start_time']),
      endTime: DateTime.parse(bookingJson['end_time']),
      lotId: bookingJson['lot_id'],
      carparkId: carparkJson['id'] ?? '',
      location: carparkJson['locations']['locations'][0].map<double>((e) => double.parse(e)).toList(),
      min: carparkJson['min'],
      cpCode: carparkJson['cp_code'],
      name: carparkJson['name'],
      rate: carparkJson['rate'],
    );
  }
}
