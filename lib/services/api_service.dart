import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:frontend_aplication/services/auth_service.dart';
import 'package:mime/mime.dart';

class ApiService {
  // Method to send an image file to the server for prediction
  static Future<Map<String, dynamic>> sendImageToServer(File image) async {
    // Define the API endpoint for prediction
    final url = Uri.parse('https://webapptestdogbreed-byhydfa4e4cycugm.westeurope-01.azurewebsites.net/predict');

    // Get the authorization token from AuthService
    final token = await AuthService.getToken();

    // Get the MIME type of the image file using mime package
    final mimeType = _getMimeType(image.path);
    if (mimeType == null) {
      throw Exception("Unsupported file format");
    }

    // Prepare the multipart request for uploading the image
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';  // Add authorization token to headers
    request.files.add(await http.MultipartFile.fromPath(
      'file',  // Field name expected by the server
      image.path,  // Path of the image file
      contentType: MediaType.parse(mimeType),  // Set content type from MIME type
    ));

    try {
      // Send the request and get the response
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Check if the response status code is OK (200)
      if (response.statusCode == 200) {
        return json.decode(responseBody);  // Return the decoded response body
      } else {
        throw Exception("Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error sending image to server: $e");
    }
  }

  // Method to send image bytes to the server for prediction
  static Future<Map<String, dynamic>> sendImageBytesToServer(Uint8List bytes) async {
    // Define the API endpoint for prediction
    final url = Uri.parse('https://webapptestdogbreed-byhydfa4e4cycugm.westeurope-01.azurewebsites.net/predict');

    // Get the authorization token from AuthService
    final token = await AuthService.getToken();

    // Get the MIME type from the image bytes using mime package
    final mimeType = lookupMimeType('', headerBytes: bytes);

    if (mimeType == null) {
      throw Exception("Unable to determine MIME type of the file");
    }

    // Prepare the multipart request for uploading the image
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';  // Add authorization token to headers
    request.files.add(http.MultipartFile.fromBytes(
      'file',  // Field name expected by the server
      bytes,  // Image bytes
      filename: 'image',  // Generic filename for the image
      contentType: MediaType.parse(mimeType),  // Set content type from MIME type
    ));

    try {
      // Send the request and get the response
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Check if the response status code is OK (200)
      if (response.statusCode == 200) {
        return json.decode(responseBody);  // Return the decoded response body
      } else {
        throw Exception("Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error sending image to server: $e");
    }
  }

  // Helper method to determine the MIME type from file extension using mime package
  static String? _getMimeType(String path) {
    final mimeType = lookupMimeType(path);  // Get the MIME type using mime package
    return mimeType;
  }
}



/*
  final url = Uri.parse('http://10.0.2.2:5000/predict'); // para emulador 
  final url = Uri.parse('http://localhost:5000/predict'); // para chrome 
  final url = Uri.parse('http://192.168.18.36:5000/predict'); // para android conectado con USB
*/