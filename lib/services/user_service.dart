import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend_aplication/models/user.dart';
import 'package:frontend_aplication/models/dog.dart';
import 'package:frontend_aplication/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  static final http.Client _client = http.Client();

  // Retrieve the base URL from environment variables
  static String get _baseUrl {
    final apiUrl = dotenv.env['BASE_URL'];
    if (apiUrl == null || apiUrl.isEmpty) {
      throw Exception("BASE_URL is not defined in environment variables.");
    }
    return apiUrl;
  }

  // Method to fetch user profile
  static Future<User?> getUserProfile() async {
    final url = Uri.parse('$_baseUrl/profile');
    final token = await AuthService.getToken();

    final response = await _client.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      if (data == null) {
        return null;
      }
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  // Method to fetch user's dogs
  static Future<List<Dog>> getUserDogs() async {
    final url = Uri.parse('$_baseUrl/get_dog');
    final token = await AuthService.getToken();

    final response = await _client.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List dogsJson = json.decode(response.body)['data'];
      return dogsJson.isEmpty ? [] : dogsJson.map((dog) => Dog.fromJson(dog)).toList();
    } else {
      throw Exception('Failed to load user dogs');
    }
  }

  // Method to update user profile
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
