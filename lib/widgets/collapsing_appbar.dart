import 'package:flutter/material.dart';

/// A custom collapsing app bar with a flexible space and a tab bar.
class CollapsingAppBar extends StatelessWidget {
  const CollapsingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.0, // Configurable expanded height
      floating: false,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        collapseMode: CollapseMode.parallax,
        titlePadding: const EdgeInsets.only(bottom: 80.0),
        title: _buildAppBarTitle(),
        background: _buildAppBarBackground(),
      ),
      bottom: _buildTabBar(),
    );
  }

  /// Builds the title for the app bar.
  Widget _buildAppBarTitle() {
    return const Text(
      "Dog Breed Detector",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }

  /// Builds the background for the app bar.
  Widget _buildAppBarBackground() {
    return Image.network(
      "https://images.pexels.com/photos/247522/pexels-photo-247522.jpeg",
      fit: BoxFit.cover,
    );
  }

  /// Builds the tab bar with its tabs.
  PreferredSizeWidget _buildTabBar() {
    return const TabBar(
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.purple,
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(icon: Icon(Icons.home_rounded), text: "Home"),
        Tab(icon: Icon(Icons.shopping_bag_rounded), text: "Breeds"),
        Tab(icon: Icon(Icons.person), text: "Profile"),
      ],
    );
  }
}
