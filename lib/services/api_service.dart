import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:frontend_aplication/services/auth_service.dart';
import 'package:mime/mime.dart';
import 'package:frontend_aplication/storage/dog_persistence.dart';

class ApiService {
  // Method to send an image and update dog breeds
  static Future<Map<String, dynamic>> sendImageToServer(File image) async {
    //final url = Uri.parse('https://webapptestdogbreed-byhydfa4e4cycugm.westeurope-01.azurewebsites.net/predict');
    final url = Uri.parse('http://127.0.0.1:5000/predict');
    final token = await AuthService.getToken();
    final mimeType = _getMimeType(image.path);

    if (mimeType == null) {
      throw Exception("Unsupported file format");
    }

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType.parse(mimeType),
    ));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);
        String breed = responseData['breed'];
        double confidence = responseData['confidence'];

        // Load previously stored races
        Map<String, double> breeds = DogBreedPersistence.loadBreeds();

        // Obtain accuracy before updating it
        double previousConfidence =
            breeds.containsKey(breed) ? breeds[breed]! : 0;

        // If the new accuracy is higher, update it
        if (confidence > previousConfidence) {
          breeds[breed] = confidence;
          DogBreedPersistence.saveBreeds(breeds);
        }

        // Adding pre-accuracy confidence
        responseData['previous_confidence'] = previousConfidence;

        return responseData;
      } else {
        throw Exception(
            "Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error sending image to server: $e");
    }
  }

  // Method to send bytes of an image to the server
  static Future<Map<String, dynamic>> sendImageBytesToServer(
      Uint8List bytes) async {
    //final url = Uri.parse('https://webapptestdogbreed-byhydfa4e4cycugm.westeurope-01.azurewebsites.net/predict');
    final url = Uri.parse('http://127.0.0.1:5000/predict');
    final token = await AuthService.getToken();
    final mimeType = lookupMimeType('', headerBytes: bytes);

    if (mimeType == null) {
      throw Exception("Unable to determine MIME type of the file");
    }

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: 'image',
      contentType: MediaType.parse(mimeType),
    ));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);
        String breed = responseData['breed'];
        double confidence = responseData['confidence'];

        Map<String, double> breeds = DogBreedPersistence.loadBreeds();

        // Get pre-accuracy
        double previousConfidence =
            breeds.containsKey(breed) ? breeds[breed]! : 0;

        // If the new accuracy is higher, update it
        if (confidence > previousConfidence) {
          breeds[breed] = confidence;
          DogBreedPersistence.saveBreeds(breeds);
        }

        // Adding pre-response accuracy
        responseData['previous_confidence'] = previousConfidence;

        return responseData;
      } else {
        throw Exception(
            "Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error sending image to server: $e");
    }
  }

  // Get MIME type of a file
  static String? _getMimeType(String path) {
    return lookupMimeType(path);
  }
}


/*
  final url = Uri.parse('http://10.0.2.2:5000/predict'); // Emulator
  final url = Uri.parse('http://localhost:5000/predict'); // Chrome
  final url = Uri.parse('http://192.168.18.36:5000/predict'); // Android connected to PC 
*/