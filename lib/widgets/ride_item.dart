import 'package:flutter/material.dart';
import '../models/ride.dart';
import '../services/api_service.dart';
import '../utils/date_formatter.dart';

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
          "Thời gian: ${DateFormatter.format(ride.time, 'dd/MM/yyyy HH:mm')}\n"
              "Lộ trình: ${ride.startLocation} → ${ride.endLocation}\n"
              "Tài xế: ${ride.driver}\n"
              "Giá vé: ${ride.price} VND",
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            bool success = await ApiService.acceptRide(ride.id, "user123");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success ? "Nhận chuyến thành công" : "Thất bại"),
              ),
            );
            if (success) onAccepted();
          },
          child: const Text("Nhận chuyến"),
        ),
      ),
    );
  }
}
