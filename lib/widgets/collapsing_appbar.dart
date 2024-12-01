import 'package:flutter/material.dart';

class CollapsingAppBar extends StatelessWidget {
  const CollapsingAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.0, // Ajusta la altura expandida si es necesario
      floating: false,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        collapseMode: CollapseMode.parallax,
        titlePadding: const EdgeInsets.only(bottom: 80.0), // Ajusta el padding del título
        title: const Text(
          "Dog Breed Detector",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        background: Image.network(
          "https://images.pexels.com/photos/247522/pexels-photo-247522.jpeg",
          fit: BoxFit.cover,
        ),
      ),
      bottom: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.purple,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(icon: Icon(Icons.home_rounded), text: "Home"),
          Tab(icon: Icon(Icons.shopping_bag_rounded), text: "Breeds"),
          Tab(icon: Icon(Icons.person), text: "Profile"),
        ],
      ),
    );
  }
}
