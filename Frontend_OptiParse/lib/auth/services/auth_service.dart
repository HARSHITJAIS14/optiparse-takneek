import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:optiparse/main.dart';

class AuthService {
  final _storage = FlutterSecureStorage();
  final String _baseUrl = MyApp.baseUrl;

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/token');
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final body = {
      'username': username,
      'password': password,
    };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      // Store the token and username securely
      await _storage.write(key: 'jwt_token', value: token);
      await _storage.write(key: 'username', value: username);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> signup(String username, String password) async {
    final url =
        Uri.parse('$_baseUrl/signup?username=$username&password=$password');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      // If signup is successful, log in the user automatically
      return await login(username, password);
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'username');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }
}
