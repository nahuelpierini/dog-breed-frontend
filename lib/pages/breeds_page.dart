import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend_aplication/widgets/breed_item_widget.dart';
import 'package:frontend_aplication/storage/dog_persistence.dart'; // importar

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

  Map<String, double> confidenceMap = {}; // Inicializamos vacío

  late Future<Map<String, dynamic>> dogInfo;

  @override
  void initState() {
    super.initState();
    dogInfo = loadDogInfo();
    loadConfidenceValues(); // Cargar valores de confianza desde localStorage
  }

  Future<Map<String, dynamic>> loadDogInfo() async {
    String jsonString =
        await rootBundle.loadString('assets/data/dog_info.json');
    return json.decode(jsonString);
  }

  void loadConfidenceValues() {
    setState(() {
      confidenceMap =
          DogBreedPersistence.loadBreeds(); // Cargar los valores guardados
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: dogInfo,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 4;
            if (constraints.maxWidth < 600) {
              crossAxisCount = 2;
            } else if (constraints.maxWidth < 900) {
              crossAxisCount = 3;
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
                String confidence =
                    confidenceMap[breedName]?.toString() ?? '0.0';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BreedItemWidget(
                    imagePath: imagePath,
                    breedName: breedName,
                    dogInfo: snapshot.data![breedName],
                    confidence: confidence,
                    imageWidth: 20,
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
