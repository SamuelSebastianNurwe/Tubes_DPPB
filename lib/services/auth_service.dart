import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final String baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/api'
      : 'http://127.0.0.1:8000/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token']; // Adjust key based on Laravel API response
        final user = data['user'];

        await _saveToken(token);
        await _saveUserRole(
          user['role'] ?? 'user',
        ); // Default to 'user' if role missing
        await _saveUserData(user['name'], user['email']);

        return {'success': true, 'user': user, 'token': token};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? specialization,
    int? experience,
  }) async {
    final endpoint = role == 'architect' ? '/register-arsitek' : '/register';
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final body = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation':
            password, // Assuming Laravel needs confirmation
        'role': role == 'architect'
            ? 'arsitek'
            : role, // Match Laravel role naming if needed, though controller hardcodes it.
      };

      if (role == 'architect') {
        if (specialization != null) body['specialization'] = specialization;
        if (experience != null) body['experience'] = experience.toString();
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Registration failed',
          'errors': errorData['errors'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  Future<void> _saveUserData(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('user_name') ?? 'Pengguna',
      'email': prefs.getString('user_email') ?? '',
      'role': prefs.getString('user_role') ?? '',
    };
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    // Optional: Call logout API endpoint if exists
  }
}
