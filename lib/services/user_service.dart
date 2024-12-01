import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend_aplication/models/user.dart';
import 'package:frontend_aplication/models/dog.dart';
import 'package:frontend_aplication/services/auth_service.dart'; // Asegúrate de importar el AuthService

class UserService {
  static const String _baseUrl = 'http://localhost:5000/';
  static final http.Client _client = http.Client();

  // Cambiado el tipo de retorno a Future<User?>
  static Future<User?> getUserProfile() async {
    final url = Uri.parse('$_baseUrl/profile');
    final token = await AuthService.getToken(); // Obtiene el token

    final response = await _client.get(
      url,
      headers: {"Authorization": "Bearer $token"}, // Usa el token aquí
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      if (data == null) {
        return null; // Retorna null si no hay datos
      }
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  static Future<List<Dog>> getUserDogs() async {
    final url = Uri.parse('$_baseUrl/get_dog');
    final token = await AuthService.getToken(); // Obtiene el token

    final response = await _client.get(
      url,
      headers: {"Authorization": "Bearer $token"}, // Usa el token aquí
    );

    if (response.statusCode == 200) {
      final List dogsJson = json.decode(response.body)['data'];
      return dogsJson.isEmpty ? [] : dogsJson.map((dog) => Dog.fromJson(dog)).toList();
    } else {
      throw Exception('Failed to load user dogs');
    }
  }

  static Future<bool> updateUserProfile(Map<String, String> updatedUser) async {
  final url = Uri.parse('$_baseUrl/profile/edit');
  final token = await AuthService.getToken();

  final response = await _client.put(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: updatedUser,
  );

  return response.statusCode == 200;
  }

}
