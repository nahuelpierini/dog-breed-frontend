import 'package:flutter/material.dart';
import 'package:frontend_aplication/pages/collapsebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CollapsingAppbarWithTabsPage(),
    );
  }
}