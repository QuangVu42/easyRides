import 'package:flutter/material.dart';

class AgentInfoScreen extends StatefulWidget {
  @override
  _AgentInfoScreenState createState() => _AgentInfoScreenState();
}

class _AgentInfoScreenState extends State<AgentInfoScreen> {
  // Mock data
  String name = "Đại lý A";
  String phone = "0123 456 789";
  String email = "dailyA@example.com";
  int points = 120;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _addPoints() {
    setState(() {
      points += 10;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Nạp thêm 10 điểm thành công!")),
    );
  }

  void _changePassword() {
    final oldPass = _oldPasswordController.text;
    final newPass = _newPasswordController.text;

    if (oldPass.isNotEmpty && newPass.isNotEmpty) {
      // TODO: call API đổi mật khẩu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đổi mật khẩu thành công")),
      );
      _oldPasswordController.clear();
      _newPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // nền sáng nhẹ
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Thông tin đại lý",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Thông tin đại lý
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blueAccent.withOpacity(0.1),
                        child: Icon(Icons.business, color: Colors.blueAccent, size: 30),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _infoRow(Icons.phone, "Số điện thoại", phone),
                  _infoRow(Icons.email, "Email", email),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Điểm: $points",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _addPoints,
                          icon: Icon(Icons.add, color: Colors.white), // 👈 icon cũng trắng
                          label: Text(
                            "Nạp thêm",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // 👈 chữ trắng
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Đổi mật khẩu
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Đổi mật khẩu",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  TextField(
                    controller: _oldPasswordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: "Mật khẩu cũ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Mật khẩu mới",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _changePassword,
                      child: Text(
                        "Xác nhận đổi mật khẩu",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
