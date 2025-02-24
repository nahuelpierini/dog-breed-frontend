/// Represents a user entity with personal details.
class User {
  final String userId; // Unique identifier for the user
  final String email;
  final String firstName;
  final String lastName;
  final String? birthDate;
  final String? country;

  /// Constructs a [User] instance with the provided attributes.
  const User({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.birthDate,
    this.country,
  });

  /// Factory constructor to create a [User] instance from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      birthDate: json['birth_date'] as String?,
      country: json['country'] as String?,
    );
  }

  /// Converts the [User] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate,
      'country': country,
    };
  }

  /// Returns the user's full name by combining [firstName] and [lastName].
  String get fullName => '$firstName $lastName';
}
