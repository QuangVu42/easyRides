import 'package:flutter/material.dart';

class DriverInfoScreen extends StatelessWidget {
  const DriverInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // mock data driver
    final String driverName = "Nguyễn Văn A";
    final String phone = "0123 456 789";
    final String email = "driver@example.com";
    final int points = 120;
    final String carType = "Toyota Vios - 4 chỗ";

    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin tài xế"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/carLogo.png"),
            ),
            SizedBox(height: 12),
            Text(
              driverName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(phone, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 20),

            // Info card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow(Icons.email, "Email", email),
                    Divider(),
                    _infoRow(Icons.star, "Điểm thưởng", "$points điểm"),
                    Divider(),
                    _infoRow(Icons.directions_car, "Xe", carType),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text(
                      "Chỉnh sửa",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // đổi màu chữ
                        letterSpacing: 1.2,  // khoảng cách chữ
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Mở form chỉnh sửa thông tin")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            "$label: $value",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
