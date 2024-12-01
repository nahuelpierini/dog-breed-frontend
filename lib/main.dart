import 'package:flutter/material.dart';
//import 'package:frontend_aplication/pages/home_page.dart';
import 'package:frontend_aplication/pages/login_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Dog Breed Detection",
      home: LoginPage(),
    );
  }
}