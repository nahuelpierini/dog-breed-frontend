import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html';

class AuthService {
  // Base URL for authentication-related API endpoints
  static const String _baseUrl =
      'https://webapptestdogbreed-byhydfa4e4cycugm.westeurope-01.azurewebsites.net/';
  //static const String _baseUrl = 'http://127.0.0.1:5000/';
  // HTTP client to perform API requests
  static final http.Client _client = http.Client();

  // Login method that authenticates the user and stores the JWT token
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await _client.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'email': email, 'password': password},
    );

    // Save token in sessionStorage if login is successul and save the emain in localStorage
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      window.sessionStorage['jwt'] = jsonResponse['access_token'];
      window.localStorage['user_email'] = email;
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

    // Send the registration request with the user's data
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

  static String? getToken() {
    return window.sessionStorage['jwt'];
  }

  // Method to log out by deleting the stored JWT token
  static Future<void> logout() async {
    window.sessionStorage.remove('jwt');
  }

  static String? getUserEmail() {
    return window.localStorage['user_email'];
  }
}
