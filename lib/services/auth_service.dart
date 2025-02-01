import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthService {
  // Base URL for authentication-related API endpoints
  //static const String _baseUrl = 'https://webapptestdogbreed-byhydfa4e4cycugm.westeurope-01.azurewebsites.net/';
  static const String _baseUrl = 'http://127.0.0.1:5000/';
  // HTTP client to perform API requests
  static final http.Client _client = http.Client();

  // Secure storage instance to store and retrieve sensitive data like tokens
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Login method that authenticates the user and stores the JWT token
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login'); // URL for login API

    // Send the login request with email and password
    final response = await _client.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      // If the login is successful, store the JWT token in secure storage
      final jsonResponse = json.decode(response.body);
      final token = jsonResponse[
          'access_token']; // Adjust according to your actual response
      await _storage.write(key: 'jwt', value: token); // Store token securely
      print("Login success!");
      return true; // Return true if login is successful
    } else {
      // Log the error and return false if login fails
      print("Login failed: ${response.body}");
      return false;
    }
  }

  // Register method to create a new user
  static Future<bool> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$_baseUrl/register'); // URL for registration API

    // Send the registration request with the user's data
    final response = await _client.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: userData, // Flutter will automatically convert the map to form-data
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Return true if registration is successful (status code 200 or 201)
      return true;
    } else {
      // Handle errors when registration fails
      final responseBody = json.decode(response.body);
      if (responseBody['message'] == 'Email already registered') {
        // Throw an exception if the email is already registered
        throw Exception('Email already registered');
      } else {
        // Log the error and throw an exception if registration fails
        print("Register failed: ${response.statusCode} - ${response.body}");
        throw Exception('Registration failed: ${responseBody['message']}');
      }
    }
  }

  // Getter for the HTTP client instance
  static http.Client get client => _client;

  // Method to get the stored JWT token
  static Future<String?> getToken() async {
    return await _storage.read(
        key: 'jwt'); // Retrieve the token from secure storage
  }

  // Method to log out by deleting the stored JWT token
  static Future<void> logout() async {
    await _storage.delete(key: 'jwt'); // Delete the token from secure storage
  }
}
