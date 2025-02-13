import 'package:flutter/material.dart';

class UnlockBanner extends StatelessWidget {
  final String breed;
  final double confidence;

  const UnlockBanner({
    super.key,
    required this.breed,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    // Solo mostrar el cartel si el porcentaje de acierto es mayor a 75
    if (confidence > 75) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.white),
            SizedBox(width: 8),
            Text(
              '¡Has desbloqueado un $breed!',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink(); // No mostrar nada si no se cumple la condición
    }
  }
}
