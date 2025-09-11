import 'package:flutter/material.dart';
import 'rides_screen.dart';
import '../components/register.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController userController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Đăng nhập",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)], // xanh nhạt → trắng
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),

        ),

            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/carLogo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: userController,
                decoration: const InputDecoration(labelText: "User ID"),
              ),
              TextField(
                controller: userController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true, // ẩn mật khẩu
              ),
              const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity, // full chiều ngang
                    child:
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const RidesScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Đăng nhập"),
                  ),
                  ),
              const SizedBox(height: 20),
              Text(
                "Nếu bạn chưa có tài khoản vui lòng đăng ký",
                style: TextStyle(
                  fontSize: 14,              // kích thước chữ
                  color: Colors.grey,        // màu chữ
                  letterSpacing: 1,        // khoảng cách giữa các ký tự
                  fontStyle: FontStyle.italic, // in nghiêng
                  decorationColor: Colors.grey,          // màu gạch
                  decorationStyle: TextDecorationStyle.dashed, // kiểu gạch (dotted, dashed, wavy)
                ),
                textAlign: TextAlign.center,  // căn giữa
                maxLines: 2,                  // số dòng tối đa
                overflow: TextOverflow.ellipsis, // hiển thị ... nếu dài quá
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, // full chiều ngang
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14), // chỉ set chiều cao
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Đăng ký",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
