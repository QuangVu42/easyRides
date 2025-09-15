import 'package:flutter/material.dart';

class PointHistoryScreen extends StatelessWidget {
  // Mock data (có thể thay bằng API sau)
  final List<Map<String, dynamic>> pointLogs = [
    {
      "time": DateTime.now().subtract(Duration(minutes: 10)),
      "description": "Nạp thêm điểm",
      "points": 20
    },
    {
      "time": DateTime.now().subtract(Duration(hours: 2)),
      "description": "Đổi quà",
      "points": 15
    },
    {
      "time": DateTime.now().subtract(Duration(days: 1)),
      "description": "Hệ thống cộng điểm thưởng",
      "points": 50
    },
  ];

  String _formatTime(DateTime time) {
    return "${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch sử điểm"),
      ),
      body: ListView.builder(
        itemCount: pointLogs.length,
        itemBuilder: (context, index) {
          final log = pointLogs[index];
          final isPositive = log["points"] > 0;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(
                isPositive ? Icons.add_circle : Icons.remove_circle,
                color: isPositive ? Colors.green : Colors.red,
              ),
              title: Text(
                log["description"],
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(_formatTime(log["time"])),
              trailing: Text(
                "${isPositive ? '+' : ''}${log["points"]} điểm",
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
