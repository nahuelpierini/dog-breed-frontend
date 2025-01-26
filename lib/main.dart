import 'package:flutter/material.dart';
import 'package:frontend_aplication/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Breed Detection',
      theme: _buildTheme(),
      home: const LoginPage(),
    );
  }

  /// Method to define and return the app's theme
  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.latoTextTheme(),
    );
  }
}
