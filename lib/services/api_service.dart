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
    //final url = Uri.parse('https://webapptestdogbreed-byhydfa4e4cycugm.westeurope-01.azurewebsites.net/predict');
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
        // Decodificar el cuerpo de la respuesta
        final responseData = json.decode(responseBody);

        // Obtener la raza y la confianza desde la respuesta
        String breed = responseData['breed'];
        double confidence = responseData['confidence'];

        // Cargar las razas guardadas previamente desde localStorage
        Map<String, double> breeds = DogBreedPersistence.loadBreeds();

        // Verificar si el valor de confianza es mayor que el almacenado
        if (breeds.containsKey(breed) && confidence > breeds[breed]!) {
          breeds[breed] = confidence; // Actualizar el valor de confianza

          // Guardar las razas actualizadas en localStorage
          DogBreedPersistence.saveBreeds(breeds);
        }

        // Retornar la respuesta del servidor
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

// Verificar si el valor de confianza es mayor que el almacenado
        if (breeds.containsKey(breed) && confidence > breeds[breed]!) {
          breeds[breed] = confidence; // Actualizar el valor de confianza

          // Guardar las razas actualizadas en localStorage
          DogBreedPersistence.saveBreeds(breeds);

          // Imprimir las razas y sus confidencias en consola
          print('Razones almacenadas después de la detección:');
          breeds.forEach((key, value) {
            print('$key: $value');
          });
        }

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