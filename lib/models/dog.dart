// models/dog.dart
class Dog {
  final String id; // Nuevo campo para identificar al perro
  final String name;
  final String breed;
  final int age;
  final String imageUrl;

  Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'], // Asegúrate de que el backend envíe este campo
      name: json['name'],
      breed: json['breed'],
      age: json['age'],
      imageUrl: json['image_url'],
    );
  }
}
