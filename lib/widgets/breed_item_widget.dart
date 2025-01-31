import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BreedItemWidget extends StatelessWidget {
  final String imagePath;
  final double accuracy;

  const BreedItemWidget({
    super.key,
    required this.imagePath,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen difuminada en blanco y negro cuando la precisión es baja
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                accuracy >= 90.0 ? Colors.transparent : Colors.grey,
                BlendMode.saturation,
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            // Agregar difuminado cuando la precisión es baja
            if (accuracy < 90.0)
              BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  color: Colors.black
                      .withOpacity(0.5), // Necesario para aplicar el filtro
                ),
              ),
          ],
        ),
      ),
    );
  }
}
