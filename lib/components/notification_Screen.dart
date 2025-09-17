import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<String> userNotifications = [
    "🎉 Bạn vừa nhận thêm 20 điểm",
    "🚖 Có chuyến đi mới cần bạn đấu giá",
    "📩 Bạn có tin nhắn mới từ Admin",
  ];

  final List<String> systemNotifications = [
    "🔑 Mật khẩu đã được thay đổi thành công",
    "⚠️ Hệ thống sẽ bảo trì lúc 23:00 tối nay",
    "🛠️ Phiên bản mới đã sẵn sàng để cập nhật",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo"),
        centerTitle: true,
        elevation: 4,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildSectionTitle("Thông báo của bạn"),
          ...userNotifications.map((n) => _buildNotificationCard(n)),
          const SizedBox(height: 16),
          _buildSectionTitle("Thông báo hệ thống"),
          ...systemNotifications.map((n) => _buildNotificationCard(n)),
        ],
      ),
    );
  }

  /// Widget tiêu đề section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// Widget hiển thị từng thông báo
  Widget _buildNotificationCard(String message) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications,
            color: Colors.blueAccent,
            size: 24,
          ),
        ),
        title: Text(
          message,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          // TODO: điều hướng tới chi tiết thông báo
        },
      ),
    );
  }
}
