import 'package:flutter/material.dart';
import '../models/Trip.dart';
import '../utils/format_Currency.dart';

class RunningScreen extends StatelessWidget {
  final Trip trip;

  const RunningScreen({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController =
    TextEditingController(text: trip.notes ?? "");

    return Scaffold(
      resizeToAvoidBottomInset: true, // 👈 tránh che khi mở bàn phím
      appBar: AppBar(title: const Text("Đang chạy")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView( // 👈 scroll khi nội dung dài
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${trip.fromLocation} → ${trip.toLocation}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                /// DRIVER INFO
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage('assets/driver.png'), // mock
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tài xế: Nguyễn Văn B",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        Text("Xe: ${trip.vehicleType ?? 'Chưa cập nhật'}",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),

                const Divider(height: 32),

                /// TRIP DETAILS
                _infoRow(Icons.attach_money,
                    "Giá yêu cầu: ${formatCurrency(trip.requestedPrice)}"),
                if (trip.bidPrice != null)
                  _infoRow(Icons.gavel,
                      "Giá đấu: ${formatCurrency(trip.bidPrice!)}"),
                _infoRow(Icons.people,
                    "Số người tham gia: ${trip.participantCount}"),
                _infoRow(Icons.access_time,
                    "Bắt đầu: ${trip.startTime.toString().substring(0, 16)}"),
                _infoRow(Icons.hourglass_bottom,
                    "Hạn đấu giá: ${trip.biddingEndTime.toString().substring(0, 16)}"),

                const SizedBox(height: 16),

                /// NOTE FIELD
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: "Ghi chú",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 24),

                /// SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Gọi API update notes
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Ghi chú đã được lưu: ${noteController.text}"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Lưu ghi chú",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Info Row helper
  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
