import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/ride.dart';

class ApiService {
  // Load danh sách chuyến từ file JSON trong assets
  static Future<List<Ride>> fetchRides() async {
    await Future.delayed(const Duration(seconds: 1)); // giả lập delay API
    final String response = await rootBundle.loadString('assets/mockdata/mock_rides.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((e) => Ride.fromJson(e)).toList();
  }

  // Mock nhận chuyến (không gọi API thật)
  static Future<bool> acceptRide(String rideId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 800)); // giả lập delay
    // có thể log ra màn hình console cho dễ debug
    print("Mock accept ride $rideId by user $userId");
    return true; // luôn thành công
  }
}
