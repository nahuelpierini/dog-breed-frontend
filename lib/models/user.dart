// models/user.dart
class User {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String? birthDate;
  final String? country;

  User({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: json['birth_date'],
      country: json['country'],
    );
  }
}
