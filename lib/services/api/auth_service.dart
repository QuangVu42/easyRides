import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/index.dart';

class AuthService {
  static final _storage = FlutterSecureStorage();
  static final _baseUrl = dotenv.env['APP_BASE_URL'] ?? "";

  static Future<User?> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await _storage.write(key: 'accessToken', value: data['accessToken']);
      await _storage.write(key: 'refreshToken', value: data['refreshToken']);

      // sau kiểm tra sau
      // return User.fromJson(data['user'])
      return data;
    }
    return null;
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}
