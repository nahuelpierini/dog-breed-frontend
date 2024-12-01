// auth_service.dart
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthService {
  static const String _baseUrl = 'http://localhost:5000/';
  static final http.Client _client = http.Client();
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await _client.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final token = jsonResponse['access_token'];  // Ajusta según tu respuesta real
      await _storage.write(key: 'jwt', value: token); // Almacena el token
      print("Login success!");
      return true; // Solo retorna true si el login es exitoso
    } else {
      print("Login failed: ${response.body}");
      return false;
    }
  }

  // Método para el registro de usuarios
  static Future<bool> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await _client.post(
      url,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: userData, // Flutter ya convierte el mapa automáticamente en form-data
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      // Manejo del error cuando el correo ya está registrado
      final responseBody = json.decode(response.body);
      if (responseBody['message'] == 'Email already registered') {
        throw Exception('Email already registered');
      } else {
        print("Register failed: ${response.statusCode} - ${response.body}");
        throw Exception('Registration failed: ${responseBody['message']}');
      }
    }
  }

  // Método para obtener el cliente con cookies
  static http.Client get client => _client;

  // Método para obtener el token JWT
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt'); // Recupera el token almacenado
  }

  // Método para eliminar el token (logout)
  static Future<void> logout() async {
    await _storage.delete(key: 'jwt'); // Elimina el token
  }
}
