import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend_aplication/services/api_service.dart'; // Importa el servicio
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'dart:typed_data'; // Importa para usar Uint8List

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  Uint8List? _webImageBytes; // Añadido para almacenar la imagen en la web
  final ImagePicker _picker = ImagePicker();
  bool _loading = false;
  String _breed = '';
  String _confidence = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.camera_alt),
                  label: Text("Tomar Foto o Cargar Imagen"),
                ),
                SizedBox(height: 16),
                if (_imageFile != null || _webImageBytes != null) // Condición para mostrar la imagen
                  ClipRect(
                    child: Container(
                      width: 150,
                      height: 150,
                      child: kIsWeb
                          ? Image.memory(
                              _webImageBytes!,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  )
                else
                  Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 50),
                  ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_loading) CircularProgressIndicator(),
                Text(
                  "Raza de Perro:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Breed: $_breed',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  "Porcentaje de acierto:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Confidence: $_confidence',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Si estamos en la web, utilizamos file_picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {
          _loading = true;
          _webImageBytes = result.files.single.bytes; // Guardar los bytes de la imagen
        });

        if (_webImageBytes != null) {
          try {
            // Enviar los bytes directamente al servidor
            final response = await ApiService.sendImageBytesToServer(_webImageBytes!);
            setState(() {
              _breed = response['breed'];
              _confidence = response['confidence'].toString();
              _loading = false;
            });
          } catch (error) {
            setState(() {
              _loading = false;
              _breed = 'Error: ${error.toString()}';
              _confidence = '';
            });
          }
        } else {
          setState(() {
            _loading = false;
            _breed = 'Error: No se pudo obtener el archivo.';
            _confidence = '';
          });
        }
      }
    } else {
      // Si estamos en un dispositivo móvil, usamos image_picker
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _loading = true;
        });

        try {
          final response = await ApiService.sendImageToServer(_imageFile!);
          setState(() {
            _breed = response['breed'];
            _confidence = response['confidence'].toString();
            _loading = false;
          });
        } catch (error) {
          setState(() {
            _loading = false;
            _breed = 'Error: ${error.toString()}';
            _confidence = '';
          });
        }
      }
    }
  }
}
