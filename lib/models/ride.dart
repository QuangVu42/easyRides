class Ride {
  final String id;
  final String code;
  final String time;       // giờ khởi hành (string cho dễ hiển thị)
  final String startLocation;
  final String endLocation;
  final String driver;
  final int price;
  final String status;

  Ride({
    required this.id,
    required this.code,
    required this.time,
    required this.startLocation,
    required this.endLocation,
    required this.driver,
    required this.price,
    required this.status,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      time: json['departure_time'] ?? '',      // map đúng key JSON
      startLocation: json['start_location'] ?? '',
      endLocation: json['end_location'] ?? '',
      driver: json['driver'] ?? '',
      price: json['price'] ?? 0,
      status: json['status'] ?? 'unknown',
    );
  }
}
