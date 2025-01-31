import 'package:flutter/material.dart';
import 'package:frontend_aplication/widgets/breed_item_widget.dart';

class BreedsPage extends StatefulWidget {
  final Map<int, String> breedNames = {
    0: "afghan_hound",
    1: "beagle",
    2: "bernese_mountain_dog",
    3: "border_collie",
    4: "boxer",
    5: "brittany_spaniel",
    6: "chihuahua",
    7: "chow",
    8: "cocker_spaniel",
    9: "dachshund",
    10: "doberman",
    11: "french_bulldog",
    12: "german_shepherd",
    13: "golden_retriever",
    14: "labrador_retriever",
    15: "pitbull",
    16: "pug",
    17: "rottweiler",
    18: "saint_bernard",
    19: "siberian_husky",
    20: "toy_poodle",
    21: "weimaraner",
    22: "whippet",
  };

  BreedsPage({super.key});

  @override
  BreedsPageState createState() => BreedsPageState();
}

class BreedsPageState extends State<BreedsPage> {
  Map<int, String> confidenceMap = {
    0: '95.0',
    1: '55.0',
    2: '65.0',
    3: '95.0',
    4: '75.0',
    5: '55.0',
    6: '55.0',
    7: '65.0',
    8: '65.0',
    9: '55.0',
    10: '55.0',
    11: '95.0',
    12: '95.0',
    13: '95.0',
    14: '95.0',
    15: '55.0',
    16: '95.0',
    17: '55.0',
    18: '55.0',
    19: '55.0',
    20: '95.0',
    21: '95.0',
    22: '15.0'
  }; // Almacena los porcentajes de acierto como String

  void updateConfidenceMap(Map<int, String> newConfidenceMap) {
    setState(() {
      confidenceMap = newConfidenceMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Número de columnas
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: widget.breedNames.length,
      itemBuilder: (context, index) {
        String breedName = widget.breedNames[index]!;
        String imagePath =
            'assets/breeds/$breedName.jpg'; // Usamos el nombre de la raza en la ruta

        double accuracy = double.tryParse(confidenceMap[index] ?? '0.0') ??
            0.0; // Conversión segura a double
        return BreedItemWidget(
          imagePath: imagePath,
          accuracy: accuracy,
        );
      },
    );
  }
}
