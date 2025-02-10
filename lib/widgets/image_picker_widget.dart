import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_aplication/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:frontend_aplication/storage/dog_persistence.dart';

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
          Text(
            "Raza de Perro",
            style: GoogleFonts.cherryBombOne(
              color: Colors.black,
              fontSize: 25.0,
            ),
          ),
          Text(
            _breed,
            style: TextStyle(fontSize: 18, fontFamily: 'RobotoMono'),
          ),
          const SizedBox(height: 8),
          Text(
            "Porcentaje de acierto",
            style: GoogleFonts.cherryBombOne(
              color: Colors.black,
              fontSize: 25.0,
            ),
          ),
          Text(
            _confidence,
            style: TextStyle(fontSize: 18, fontFamily: 'RobotoMono'),
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

  final Map<String, String> breedTranslations = {
    "afghan_hound": "Lebrel Afgano",
    "beagle": "Beagle",
    "bernese_mountain_dog": "Boyero de Berna",
    "border_collie": "Border Collie",
    "boxer": "Bóxer",
    "brittany_spaniel": "Bretón",
    "chihuahua": "Chihuahua",
    "chow": "Chow Chow",
    "cocker_spaniel": "Cocker Spaniel",
    "dachshund": "Perro Salchicha",
    "doberman": "Dóberman",
    "french_bulldog": "Bulldog Francés",
    "german_shepherd": "Pastor Alemán",
    "golden_retriever": "Golden Retriever",
    "labrador_retriever": "Labrador Retriever",
    "pitbull": "Pitbull",
    "pug": "Pug",
    "rottweiler": "Rottweiler",
    "saint_bernard": "San Bernardo",
    "siberian_husky": "Husky Siberiano",
    "toy_poodle": "Caniche Toy",
    "weimaraner": "Weimaraner",
    "whippet": "Galgo"
  };

  /// Updates the breed and confidence information based on the server response.
  void _updateResults(Map<String, dynamic> response) {
    setState(() {
      String breedEnglish = response['breed'];
      _breed = breedTranslations[breedEnglish] ?? breedEnglish;
      _confidence = response['confidence'].toString();
      _loading = false;

      double confidenceValue = double.parse(_confidence);
      double previousConfidence = response['previous_confidence'] ?? 0;

      print("Breed: $breedEnglish");
      print("Confidence Value (New): $confidenceValue");
      print("Previous Confidence (Stored): $previousConfidence");

      // Verificar si la raza aún no ha sido descubierta con confianza ≥ 75
      bool isNewBreed = previousConfidence < 75;

      if (confidenceValue > 75 && isNewBreed) {
        print("Showing unlock dialog for: $_breed");
        _showUnlockDialog(_breed);
      }

      // Guardar la nueva confianza en el almacenamiento
      Map<String, double> discoveredBreeds = DogBreedPersistence.loadBreeds();
      discoveredBreeds[breedEnglish] = confidenceValue;
      DogBreedPersistence.saveBreeds(discoveredBreeds);
    });
  }

  void _showUnlockDialog(String breed) {
    AwesomeDialog(
      context: context,
      customHeader: _AnimatedCheckIcon(), // Usa el widget con animación fluida
      title: '¡Excelente!',
      body: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '¡Has desbloqueado un ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: '$breed',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '!\n\nVe a la sección "',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: 'Razas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '" y mira la carta.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
      animType: AnimType.scale,
      width: 400,
      buttonsBorderRadius: BorderRadius.circular(8),
      btnOkText: '¡Genial!',
      btnOkColor: Color.fromARGB(255, 130, 166, 196),
      btnOkOnPress: () {
        print('Raza desbloqueada: $breed');
      },
    ).show();
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

// ✅ **Widget para la animación fluida del icono**
class _AnimatedCheckIcon extends StatefulWidget {
  @override
  _AnimatedCheckIconState createState() => _AnimatedCheckIconState();
}

class _AnimatedCheckIconState extends State<_AnimatedCheckIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800), // Duración animación
      vsync: this,
    );

    // Animación de escala con rebote
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Rebote suave
    );

    // Animación de rotación ligera
    _rotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(); // Iniciar animación al mostrar el diálogo
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value, // Rotación ligera
          child: Transform.scale(
            scale: _scaleAnimation.value, // Efecto de rebote
            child: Icon(
              Icons.check_circle,
              size: 100,
              color: Color.fromARGB(255, 130, 166, 196), // Color ámbar
            ),
          ),
        );
      },
    );
  }
}
