import 'package:flutter/material.dart';
import '../models/Trip.dart';
import '../services/MockDataService.dart';
import '../utils/countdown_Text.dart';
import '../utils/format_Currency.dart';

class AcceptedScreen extends StatelessWidget {
  final Trip trip;

  const AcceptedScreen({Key? key, required this.trip}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đã nhận")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
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
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                      backgroundImage: AssetImage('assets/driver.png'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text("Tài xế: ${trip.driverName ?? 'Nguyễn Văn B'}",
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
                    "Giá yêu cầu: ${formatCurrency(500000)}"),
                if (trip.bidPrice != null)
                  _infoRow(Icons.gavel,
                      "Giá đấu: ${formatCurrency(400000)}"),
                _infoRow(Icons.people,
                    "Số người tham gia: ${trip.participantCount}"),
                _infoRow(Icons.access_time,
                    "Bắt đầu: ${trip.startTime.toString().substring(0, 16)}"),
                if (trip.notes != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text("Ghi chú: ${trip.notes}",
                        style: const TextStyle(color: Colors.black54)),
                  ),

                const Spacer(),

                /// ACTION BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _confirmCancel(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Hủy chuyến"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showChangeDriverDialog(context, trip);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Chuyển đổi"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Xác nhận hủy chuyến"),
          content: SizedBox(
            width: MediaQuery.of(ctx).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("⚠️ Nếu bạn hủy chuyến này:"),
                SizedBox(height: 8),
                Text("- Bạn sẽ bị trừ 10 điểm uy tín."),
                Text("- Có thể ảnh hưởng đến quyền nhận chuyến sau."),
                Text("- Hệ thống sẽ ghi lại lịch sử hủy."),
                SizedBox(height: 12),
                Text("Bạn có chắc chắn muốn hủy không?",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Không"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bạn đã hủy chuyến. Điểm bị trừ: 10"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white),
              child: const Text("Hủy chuyến"),
            ),
          ],
        );
      },
    );
  }
}

/// Chuyển đổi tài xế
void _showChangeDriverDialog(BuildContext context, Trip trip) {
  final TextEditingController noteController = TextEditingController();
  String? selectedDriverId;

  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Chọn người chuyển đổi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: MediaQuery.of(ctx).size.width * 0.9,
              height: 400, // fix chiều cao
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: MockDataService.drivers.length,
                      itemBuilder: (context, index) {
                        final driver = MockDataService.drivers[index];
                        final isSelected = driver.id == selectedDriverId;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDriverId = driver.id;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue.shade50 : Colors.white,
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.blueAccent,
                                  child: Text(driver.name[0],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(driver.name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                      Text(driver.phone,
                                          style: TextStyle(color: Colors.grey[600])),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle,
                                      color: Colors.blue, size: 24),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
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
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Hủy",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedDriverId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Vui lòng chọn 1 tài xế trước")),
                    );
                    return;
                  }
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Đã chuyển sang tài xế mới (ID: $selectedDriverId). Ghi chú: ${noteController.text}")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text("Xác nhận"),
              ),
            ],
          );
        },
      );
    },
  );
}
