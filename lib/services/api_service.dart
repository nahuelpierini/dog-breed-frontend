import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mime/mime.dart';
import 'package:frontend_aplication/services/auth_service.dart';

class ApiService {
  // Method to send an image file to the server
  static Future<Map<String, dynamic>> sendImageToServer(File image) async {
    final apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null || apiUrl.isEmpty) {
      throw Exception("API URL is not defined in environment variables.");
    }
    final url = Uri.parse(apiUrl);

    final token = await AuthService.getToken();
    final mimeType = _getMimeType(image.path);
    if (mimeType == null) {
      throw Exception("Unsupported file format");
    }

    // Prepare the multipart request to upload the image
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType.parse(mimeType),
    ));

    try {
      // Send the request and process the response
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception("Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error sending image to server: $e");
    }
  }

  // Method to send image bytes to the server
  static Future<Map<String, dynamic>> sendImageBytesToServer(Uint8List bytes) async {
    final apiUrl = dotenv.env['API_URL'];
    if (apiUrl == null || apiUrl.isEmpty) {
      throw Exception("API URL is not defined in environment variables.");
    }
    final url = Uri.parse(apiUrl);

    final token = await AuthService.getToken();
    final mimeType = lookupMimeType('', headerBytes: bytes);

    if (mimeType == null) {
      throw Exception("Unable to determine MIME type of the file");
    }

    // Prepare the multipart request to upload the image bytes
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: 'image',
      contentType: MediaType.parse(mimeType),
    ));

    try {
      // Send the request and process the response
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception("Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error sending image to server: $e");
    }
  }

  // Helper method to get the MIME type based on the file extension
  static String? _getMimeType(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType;
  }
}
