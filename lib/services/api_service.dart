import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:frontend_aplication/services/auth_service.dart';
import 'package:mime/mime.dart';
import 'package:frontend_aplication/storage/dog_persistence.dart'; // Importar la clase DogBreedPersistence

class ApiService {
  // Método para enviar una imagen y actualizar las razas de perro
  static Future<Map<String, dynamic>> sendImageToServer(File image) async {
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

        // Cargar las razas previamente almacenadas
        Map<String, double> breeds = DogBreedPersistence.loadBreeds();

        // Obtener la confianza previa antes de actualizarla
        double previousConfidence =
            breeds.containsKey(breed) ? breeds[breed]! : 0;

        // Si la nueva confianza es mayor, actualizarla
        if (confidence > previousConfidence) {
          breeds[breed] = confidence;
          DogBreedPersistence.saveBreeds(breeds);
        }

        // Agregar la confianza previa a la respuesta
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

  // Método para enviar bytes de una imagen al servidor
  static Future<Map<String, dynamic>> sendImageBytesToServer(
      Uint8List bytes) async {
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

        // Obtener la confianza previa
        double previousConfidence =
            breeds.containsKey(breed) ? breeds[breed]! : 0;

        // Si la nueva confianza es mayor, actualizarla
        if (confidence > previousConfidence) {
          breeds[breed] = confidence;
          DogBreedPersistence.saveBreeds(breeds);
        }

        // Agregar la confianza previa a la respuesta
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

  // Método para obtener el MIME type del archivo
  static String? _getMimeType(String path) {
    return lookupMimeType(path);
  }
}



/*
  final url = Uri.parse('http://10.0.2.2:5000/predict'); // para emulador 
  final url = Uri.parse('http://localhost:5000/predict'); // para chrome 
  final url = Uri.parse('http://192.168.18.36:5000/predict'); // para android conectado con USB
*/