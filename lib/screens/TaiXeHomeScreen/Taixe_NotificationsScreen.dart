import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<String> notifications = [
    "Chuyến đi Hà Nội → Hải Phòng đã được duyệt",
    "Chuyến đi Thanh Hóa → Ninh Bình đã bị hủy",
    "Bạn có chuyến mới được gán: Đà Nẵng → Hội An",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(Icons.notifications, color: Colors.orange),
            title: Text(notifications[index]),
          ),
        );
      },
    );
  }
}
