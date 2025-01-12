/// Represents a dog entity with essential attributes.
class Dog {
  final String id; // Unique identifier for the dog
  final String name;
  final String breed;
  final int age;
  final String imageUrl;

  /// Constructs a [Dog] instance with the provided attributes.
  const Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
  });

  /// Factory constructor to create a [Dog] instance from a JSON map.
  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'] as String, // Ensures type safety
      name: json['name'] as String,
      breed: json['breed'] as String,
      age: json['age'] as int,
      imageUrl: json['image_url'] as String,
    );
  }

  /// Converts the [Dog] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'image_url': imageUrl,
    };
  }
}
