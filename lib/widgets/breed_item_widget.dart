import 'package:flutter/material.dart';
import 'dart:ui'; // Para usar el BackdropFilter
import 'package:google_fonts/google_fonts.dart';

class BreedItemWidget extends StatefulWidget {
  final String imagePath;
  final String breedName;
  final Map<String, dynamic> dogInfo;
  final String confidence;

  const BreedItemWidget(
      {required this.imagePath,
      required this.breedName,
      required this.dogInfo,
      required this.confidence,
      required int imageWidth});

  @override
  BreedItemWidgetState createState() => BreedItemWidgetState();
}

class BreedItemWidgetState extends State<BreedItemWidget> {
  bool showInfo = false;

  @override
  Widget build(BuildContext context) {
    double confidenceValue = double.tryParse(widget.confidence) ?? 0.0;
    const double confidence = 70;

    return GestureDetector(
      onTap: () {
        setState(() {
          showInfo = false;
        });
      },
      child: Stack(
        children: [
          // Imagen con efecto de desenfoque si la precisión es baja
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: confidenceValue < confidence
                      ? ColorFilter.mode(Colors.blueGrey, BlendMode.saturation)
                      : ColorFilter.mode(
                          Colors.transparent, BlendMode.saturation),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                if (confidenceValue < confidence)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),

          // Título encima de la imagen, sin taparla
          Positioned(
            top: 0, // Posición en la parte superior
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5), // Espaciado del texto
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 130, 166, 196), // Fondo de color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.dogInfo['raza'].toUpperCase(),
                  style: GoogleFonts.cherryBombOne(
                    color: confidenceValue < confidence
                        ? Color.fromARGB(255, 130, 166, 196)
                        : Colors.white, // Cambio de color según confianza
                    fontSize: 15.0,
                    backgroundColor: Colors
                        .transparent, // Evitar superposición con Container
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: confidenceValue < confidence
                  ? Colors.grey
                  : const Color.fromARGB(255, 130, 166, 196),
              onPressed: confidenceValue < confidence
                  ? null
                  : () {
                      setState(() {
                        showInfo = !showInfo;
                      });
                    },
              child: Icon(Icons.info, color: Colors.white),
            ),
          ),
          if (showInfo)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showInfo = false),
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.pets,
                                      size: 20,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '   ${widget.dogInfo['raza']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.sentiment_satisfied,
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '   ${widget.dogInfo['temperamento']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.palette,
                                      size: 20,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '   ${widget.dogInfo['colores']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.flag,
                                      size: 20,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '   ${widget.dogInfo['origen']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.favorite,
                                        size: 20, color: Colors.red),
                                  ),
                                  TextSpan(
                                    text: '   ${widget.dogInfo['vida']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.straighten,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '   ${widget.dogInfo['altura']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.scale,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '   ${widget.dogInfo['peso']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.info,
                                      size: 20,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '   ${widget.dogInfo['info']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
