class User {
  final String id;
  final String name;
  final String phone;
  final int points;
  final String token;
  final int role;

  User({required this.id, required this.name, required this.phone, required this.points, required this.token, required this.role});
}

class Driver {
  final String id;
  final String name;
  final String phone;

  Driver({required this.id, required this.name, required this.phone});
}

class Vehicle {
  final String id;
  final String type;
  final String licensePlate;
  final String driverId;

  Vehicle({required this.id, required this.type, required this.licensePlate, required this.driverId});
}
