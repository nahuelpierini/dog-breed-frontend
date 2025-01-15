import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AuthService {
  static final http.Client _client = http.Client();
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Retrieve the base URL from environment variables
  static String get _baseUrl {
    final apiUrl = dotenv.env['BASE_URL'];
    if (apiUrl == null || apiUrl.isEmpty) {
      throw Exception("BASE_URL is not defined in environment variables.");
    }
    return apiUrl;
  }

  // Login method that authenticates the user and stores the JWT token
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await _client.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final token = jsonResponse['access_token']; 
      await _storage.write(key: 'jwt', value: token);
      print("Login success!");
      return true;
    } else {
      print("Login failed: ${response.body}");
      return false;
    }
  }

  // Register method to create a new user
  static Future<bool> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$_baseUrl/register');

    final response = await _client.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: userData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final responseBody = json.decode(response.body);
      if (responseBody['message'] == 'Email already registered') {
        throw Exception('Email already registered');
      } else {
        print("Register failed: ${response.statusCode} - ${response.body}");
        throw Exception('Registration failed: ${responseBody['message']}');
      }
    }
  }

  static http.Client get client => _client;

  // Method to get the stored JWT token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  // Method to log out by deleting the stored JWT token
  static Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }
}
