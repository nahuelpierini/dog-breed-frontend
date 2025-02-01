import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend_aplication/widgets/breed_item_widget.dart';

class BreedsPage extends StatefulWidget {
  @override
  BreedsPageState createState() => BreedsPageState();
}

class BreedsPageState extends State<BreedsPage> {
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

  Map<int, String> confidenceMap = {
    0: '95.0',
    1: '55.0',
    2: '95.0',
    3: '95.0',
    4: '55.0',
    5: '95.0',
    6: '55.0',
    7: '55.0',
    8: '55.0',
    9: '95.0',
    10: '95.0',
    11: '95.0',
    12: '55.0',
    13: '55.0',
    14: '55.0',
    15: '55.0',
    16: '95.0',
    17: '95.0',
    18: '55.0',
    19: '55.0',
    20: '95.0',
    21: '95.0',
    22: '95.0',
  };

  late Future<Map<String, dynamic>> dogInfo;

  @override
  void initState() {
    super.initState();
    dogInfo = loadDogInfo();
  }

  Future<Map<String, dynamic>> loadDogInfo() async {
    String jsonString =
        await rootBundle.loadString('assets/data/dog_info.json');
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: dogInfo,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Usamos LayoutBuilder para ajustar el número de columnas
        return LayoutBuilder(
          builder: (context, constraints) {
            // Determinamos el número de columnas según el ancho de la pantalla
            int crossAxisCount = 4; // Default para pantallas grandes

            if (constraints.maxWidth < 600) {
              crossAxisCount = 2; // 1 columna para pantallas pequeñas
            } else if (constraints.maxWidth < 900) {
              crossAxisCount = 3; // 2 columnas para pantallas medianas
            }

            return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: breedNames.length,
              itemBuilder: (context, index) {
                String breedName = breedNames[index]!;
                String imagePath =
                    'assets/breeds/${breedName.toLowerCase().replaceAll(" ", "_")}.jpg';
                String confidence = confidenceMap[index] ?? '0.0';

                // Ajustar el tamaño de la imagen para que no ocupe toda la celda
                return Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Ajustar el padding para hacer las celdas más pequeñas
                  child: BreedItemWidget(
                    imagePath: imagePath,
                    breedName: breedName,
                    dogInfo: snapshot.data![breedName],
                    confidence: confidence,
                    imageWidth: 20, // Ajustar el ancho de las imágenes
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
