import 'package:http/http.dart' as http;
import 'package:frontend_aplication/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DogService {
  static final http.Client _client = http.Client();

  // Retrieve the base URL from environment variables
  static String get _baseUrl {
    final apiUrl = dotenv.env['BASE_URL'];
    if (apiUrl == null || apiUrl.isEmpty) {
      throw Exception("BASE_URL is not defined in environment variables.");
    }
    return apiUrl;
  }

  // Method to update a dog's information
  static Future<void> updateDog(String dogId, Map<String, String> dogData) async {
    final url = Uri.parse('$_baseUrl/edit_dog/$dogId');
    final token = await AuthService.getToken();

    final response = await _client.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: dogData,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update dog');
    }
  }

  // Method to create a new dog
  static Future<void> createDog(Map<String, String> dogData) async {
    final url = Uri.parse('$_baseUrl/upload_dog');
    final token = await AuthService.getToken();

    final response = await _client.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: dogData,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create dog');
    }
  }
}
