import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html'; // Para trabajar con localStorage en Web

/*
VER SI PUEDO EVITAR ALMACENAR EL TOKEN EN LOCAL STORAGE  Y SOLO USAR EL EMAIL
*/
class AuthService {
  // Base URL for authentication-related API endpoints
  static const String _baseUrl =
      'https://webapptestdogbreed-byhydfa4e4cycugm.westeurope-01.azurewebsites.net/';
  //static const String _baseUrl = 'http://127.0.0.1:5000/';
  // HTTP client to perform API requests
  static final http.Client _client = http.Client();

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
      // If the login is successful, store the JWT token in localStorage
      final jsonResponse = json.decode(response.body);
      final token = jsonResponse[
          'access_token']; // Adjust according to your actual response
      window.localStorage['jwt'] = token; // Store token in localStorage
      window.localStorage['user_email'] = email; // Guardar email del usuario
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
  static String? getToken() {
    return window.localStorage['jwt']; // Retrieve the token from localStorage
  }

  // Method to log out by deleting the stored JWT token
  static Future<void> logout() async {
    window.localStorage.remove('jwt'); // Delete the token from localStorage
  }

  // Método para obtener el email del usuario actual
  static String? getUserEmail() {
    return window.localStorage['user_email'];
  }
}
