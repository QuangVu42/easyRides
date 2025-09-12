import 'package:flutter/material.dart';
import '../models/Trip.dart';
import '../services/MockDataService.dart';
import '../models/index.dart';

class PendingScreen extends StatelessWidget {
  final Trip trip;

  const PendingScreen({Key? key, required this.trip}) : super(key: key);

  String _formatCurrency(int amount) {
    return "${amount.toString()} đ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chờ duyệt")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      label: const Text("Chờ duyệt"),
                      backgroundColor: Colors.orange.shade100,
                      labelStyle: const TextStyle(color: Colors.orange),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // Driver info
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
                        // Text("Tài xế: ${trip.driverName ?? 'Đang cập nhật'}",
                          Text("Tài xế: Nguyễn văn B}",
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
                Text("Giá yêu cầu: ${_formatCurrency(100000)}"),
                if (trip.bidPrice != null)
                  Text("Giá đấu: ${_formatCurrency(40000!)}"),
                Text("Số người tham gia: ${trip.participantCount}"),
                Text("Bắt đầu: ${trip.startTime}"),
                Text("Hạn đấu giá: ${trip.biddingEndTime}"),
                if (trip.notes != null)
                  Text("Ghi chú: ${trip.notes}"),

                const Spacer(),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: const Text("Xác nhận hủy chuyến"),
                                content: Column(
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
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(); // đóng dialog
                                    },
                                    child: const Text("Không"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(); // đóng dialog
                                      // TODO: gọi API hủy chuyến / cập nhật status
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Bạn đã hủy chuyến. Điểm bị trừ: 10"),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Hủy chuyến"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
}

void _showChangeDriverDialog(BuildContext context, Trip trip) {
  final TextEditingController noteController = TextEditingController();
  String? selectedDriverId;

  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Chọn tài xế mới"),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Danh sách driver
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: MockDataService.drivers.length,
                      itemBuilder: (context, index) {
                        final driver = MockDataService.drivers[index];
                        final isSelected = driver.id == selectedDriverId;

                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(driver.name[0]),
                          ),
                          title: Text(driver.name),
                          subtitle: Text(
                              "${driver.phone} "),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle,
                              color: Colors.green)
                              : null,
                          onTap: () {
                            setState(() {
                              selectedDriverId = driver.id;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Note
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      labelText: "Ghi chú",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Hủy"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedDriverId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Vui lòng chọn 1 tài xế trước")),
                    );
                    return;
                  }

                  // TODO: update trip.selectedDriverId = selectedDriverId
                  // + lưu noteController.text

                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Đã chuyển sang tài xế mới (ID: $selectedDriverId). Ghi chú: ${noteController.text}")),
                  );
                },
                child: const Text("Xác nhận"),
              ),
            ],
          );
        },
      );
    },
  );
}

