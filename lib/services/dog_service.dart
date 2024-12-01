// dog_service.dart
import 'package:http/http.dart' as http;
import 'package:frontend_aplication/services/auth_service.dart';

class DogService {
  static const String _baseUrl = 'http://localhost:5000/';
  static final http.Client _client = http.Client();

  static Future<void> updateDog(String dogId, Map<String, String> dogData) async {
    final url = Uri.parse('$_baseUrl/edit_dog/$dogId');
    final token = await AuthService.getToken();

    final response = await _client.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: dogData, // No es necesario incluir imageUrl si no hay imagen
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update dog');
    }
  }

  static Future<void> createDog(Map<String, String> dogData) async {
    final url = Uri.parse('$_baseUrl/upload_dog');
    final token = await AuthService.getToken();

    final response = await _client.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: dogData, // No incluir la imagen si no se sube una
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create dog');
    }
  }
  
}
