import 'package:flutter/material.dart';
import '../models/Trip.dart';
import '../services/MockDataService.dart';
import '../utils/format_Currency.dart';

class RunningScreen extends StatelessWidget {
  final Trip trip;

  const RunningScreen({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController =
    TextEditingController(text: trip.notes ?? "");

    return Scaffold(
      appBar: AppBar(title: const Text("Đã nhận")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${trip.fromLocation} → ${trip.toLocation}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: const Text("Đã nhận"),
                      backgroundColor: Colors.green,
                      labelStyle: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // Driver info
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage:
                      AssetImage('assets/driver.png'), // mock
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tài xế: Nguyễn Văn B",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        Text("Xe: ${trip.vehicleType}",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Trip details
                Text("Giá yêu cầu: ${formatCurrency(100000)}"),
                if (trip.bidPrice != null)
                  Text("Giá đấu: ${formatCurrency(trip.bidPrice!)}"),
                Text("Số người tham gia: ${trip.participantCount}"),
                Text("Bắt đầu: ${trip.startTime}"),
                Text("Hạn đấu giá: ${trip.biddingEndTime}"),

                const SizedBox(height: 16),

                // Note field
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: "Ghi chú",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),

                const Spacer(),

                // Save note button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Lưu noteController.text vào trip.notes hoặc gọi API update
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Ghi chú đã được lưu: ${noteController.text}")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Lưu ghi chú"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
