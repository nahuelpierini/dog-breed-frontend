import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_aplication/services/api_service.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  ImagePickerWidgetState createState() => ImagePickerWidgetState();
}

class ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;
  Uint8List? _webImageBytes;
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
          _buildImageSection(),
          const SizedBox(width: 16),
          _buildInfoSection(),
        ],
      ),
    );
  }

  /// Builds the image display and upload button section.
  Widget _buildImageSection() {
    return Expanded(
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.camera_alt),
            label: LayoutBuilder(
              builder: (context, constraints) {
                double fontSize = constraints.maxWidth > 200 ? 16 : 12;
                return Text(
                  "Tomar Foto o Cargar Imagen",
                  style: TextStyle(fontSize: fontSize),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildImagePreview(),
        ],
      ),
    );
  }

  /// Builds the preview of the selected image.
  Widget _buildImagePreview() {
    if (_imageFile != null || _webImageBytes != null) {
      return ClipRect(
        child: SizedBox(
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
      );
    } else {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dog_shadow.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  /// Builds the section displaying breed and confidence information.
  Widget _buildInfoSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_loading) const CircularProgressIndicator(),
          const Text(
            "Raza de Perro:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            _breed,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            "Porcentaje de acierto:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            _confidence,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Handles image selection and uploads the image for processing.
  Future<void> _pickImage() async {
    if (kIsWeb) {
      await _pickWebImage();
    } else {
      await _pickMobileImage();
    }
  }

  /// Picks an image on web platforms and processes it.
  Future<void> _pickWebImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _loading = true;
        _webImageBytes = result.files.single.bytes;
      });

      if (_webImageBytes != null) {
        await _sendImageBytesToServer(_webImageBytes!);
      } else {
        _handleError("No se pudo obtener el archivo.");
      }
    }
  }

  /// Picks an image on mobile platforms and processes it.
  Future<void> _pickMobileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _loading = true;
      });

      await _sendImageFileToServer(_imageFile!);
    }
  }

  /// Sends the selected image bytes to the server.
  Future<void> _sendImageBytesToServer(Uint8List bytes) async {
    try {
      final response = await ApiService.sendImageBytesToServer(bytes);
      _updateResults(response);
    } catch (error) {
      _handleError(error.toString());
    }
  }

  /// Sends the selected image file to the server.
  Future<void> _sendImageFileToServer(File file) async {
    try {
      final response = await ApiService.sendImageToServer(file);
      _updateResults(response);
    } catch (error) {
      _handleError(error.toString());
    }
  }

  /// Updates the breed and confidence information based on the server response.
  void _updateResults(Map<String, dynamic> response) {
    setState(() {
      _breed = response['breed'];
      _confidence = response['confidence'].toString();
      _loading = false;
    });
  }

  /// Handles errors during image processing or server communication.
  void _handleError(String error) {
    setState(() {
      _loading = false;
      _breed = 'Error: $error';
      _confidence = '';
    });
  }
}
