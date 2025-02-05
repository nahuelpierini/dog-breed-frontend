import 'dart:convert';
import 'dart:html';
import 'package:frontend_aplication/services/auth_service.dart';

class DogBreedPersistence {
  // Obtener clave específica para el usuario
  static String _getUserStorageKey() {
    String? email = AuthService.getUserEmail();
    if (email == null) {
      throw Exception("No user is logged in");
    }
    return 'user_dog_breeds_$email'; // Clave específica por usuario
  }

  // Guardar los datos de las razas en localStorage
  static void saveBreeds(Map<String, double> breeds) {
    try {
      String key = _getUserStorageKey();
      String breedsJson = json.encode(breeds);
      window.localStorage[key] = breedsJson;
    } catch (e) {
      print("Error saving breeds: $e");
    }
  }

  // Cargar los datos de las razas desde localStorage
  static Map<String, double> loadBreeds() {
    try {
      String key = _getUserStorageKey();
      String? breedsJson = window.localStorage[key];

      if (breedsJson == null) {
        return initializeBreeds();
      }

      return Map<String, double>.from(json.decode(breedsJson));
    } catch (e) {
      print("Error loading breeds: $e");
      return initializeBreeds();
    }
  }

  // Inicializar las razas con confianza 0
  static Map<String, double> initializeBreeds() {
    return {
      "afghan_hound": 0,
      "beagle": 0,
      "bernese_mountain_dog": 0,
      "border_collie": 0,
      "boxer": 0,
      "brittany_spaniel": 0,
      "chihuahua": 0,
      "chow": 0,
      "cocker_spaniel": 0,
      "dachshund": 0,
      "doberman": 0,
      "french_bulldog": 0,
      "german_shepherd": 0,
      "golden_retriever": 0,
      "labrador_retriever": 0,
      "pitbull": 0,
      "pug": 0,
      "rottweiler": 0,
      "saint_bernard": 0,
      "siberian_husky": 0,
      "toy_poodle": 0,
      "weimaraner": 0,
      "whippet": 0,
    };
  }
}
