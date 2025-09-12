class User {
  final String id;
  final String name;
  final String phone;
  final int points;
  final String token;

  User({required this.id, required this.name, required this.phone, required this.points, required this.token});
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
