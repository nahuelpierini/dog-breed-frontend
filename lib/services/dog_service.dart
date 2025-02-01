import 'package:http/http.dart' as http;
import 'package:frontend_aplication/services/auth_service.dart';

class DogService {
  //static const String _baseUrl = 'https://webapptestdogbreed-byhydfa4e4cycugm.westeurope-01.azurewebsites.net/';
  static const String _baseUrl = 'http://127.0.0.1:5000/';
  static final http.Client _client = http.Client();

  static Future<void> updateDog(
      String dogId, Map<String, String> dogData) async {
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
