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

  final TextEditingController _oldPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController =
  TextEditingController();

  void _addPoints() {
    setState(() {
      points += 10; // ví dụ mỗi lần nạp thêm 10 điểm
    });
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
      appBar: AppBar(
        title: Text("Thông tin đại lý"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Thông tin đại lý
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Thông tin đại lý",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text("Tên: $name"),
                  Text("Số điện thoại: $phone"),
                  Text("Email: $email"),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Điểm: $points",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      ElevatedButton(
                        onPressed: _addPoints,
                        child: Text("Nạp thêm"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Đổi mật khẩu
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
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
                      labelText: "Mật khẩu cũ",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: "Mật khẩu mới",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _changePassword,
                    child: Text("Xác nhận đổi mật khẩu"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
