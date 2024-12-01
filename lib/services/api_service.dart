import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';


class ApiService {
  // Método existente para enviar imagen desde el archivo
  static Future<Map<String, dynamic>> sendImageToServer(File image) async {
    final url = Uri.parse('http://localhost:5000/predict');

    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception("Error en la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error enviando la imagen al servidor");
    }
  }

  // Nuevo método para enviar bytes directamente
  static Future<Map<String, dynamic>> sendImageBytesToServer(Uint8List bytes) async {
    final url = Uri.parse('http://localhost:5000/predict');

    final request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: 'image.png'));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception("Error en la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error enviando la imagen al servidor");
    }
  }
}




/*
  final url = Uri.parse('http://10.0.2.2:5000/predict'); // para emulador 
  final url = Uri.parse('http://localhost:5000/predict'); // para chrome 
  final url = Uri.parse('http://192.168.18.36:5000/predict'); // para android conectado con USB
*/