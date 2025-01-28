import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom collapsing app bar with a flexible space and a tab bar.
class CollapsingAppBar extends StatelessWidget {
  const CollapsingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.0,
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
    return Text(
      "Doggy Detective",
      style: GoogleFonts.cherryBombOne(
        fontWeight: FontWeight.bold,
        fontSize: 30.0,
      ),
    );
  }

  /// Builds the background for the app bar.
  Widget _buildAppBarBackground() {
    return Image.asset(
      'assets/images/back2.png',
      fit: BoxFit.cover,
    );
  }

  /// Builds the tab bar with its tabs.
  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70.0),
      child: Container(
        color: const Color.fromARGB(255, 122, 25, 106),
        height: 60.0,
        child: const TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.white,
          unselectedLabelColor: Color.fromARGB(173, 158, 158, 158),
          tabs: [
            Tab(icon: Icon(Icons.home_rounded), text: "Detective"),
            Tab(icon: Icon(Icons.shopping_bag_rounded), text: "Breeds"),
            Tab(icon: Icon(Icons.person), text: "Profile"),
          ],
        ),
      ),
    );
  }
}
