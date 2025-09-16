import 'package:flutter/material.dart';
import '../models/ride.dart';
import '../services/api_service.dart';
import '../utils/date_formatter.dart';
import '../components/Driver_Map_View.dart'; // import màn chi tiết có map

class RideItem extends StatelessWidget {
  final Ride ride;
  final VoidCallback onAccepted;

  const RideItem({super.key, required this.ride, required this.onAccepted});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text("Mã chuyến: ${ride.code}"),
        subtitle: Text(
          "Tài xế: ${ride.driver}\n"
              "Giá vé: ${ride.price} VND",
        ),
        // 👉 Thêm onTap để mở chi tiết chuyến đi
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DriverMapView(ride: ride),
            ),
          );
        },
      ),
    );
  }
}
