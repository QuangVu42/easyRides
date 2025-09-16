import 'package:flutter/material.dart';
import '../login_screen.dart'; // nhớ import nếu LoginScreen là widget riêng

class DriverSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text("Thông tin tài xế"),
          subtitle: Text("Tên, số điện thoại, email"),
          onTap: () {
            // TODO: mở màn chỉnh sửa thông tin
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text("Đổi mật khẩu"),
          onTap: () {
            // TODO: mở màn đổi mật khẩu
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text("Đăng xuất"),
          onTap: () {
            // 👉 Khi logout thì quay về màn login
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',   // route name đã khai báo trong MaterialApp
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );
  }
}
