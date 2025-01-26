import 'package:flutter/material.dart';
import 'package:frontend_aplication/widgets/collapsing_appbar.dart';
import 'package:frontend_aplication/widgets/image_picker_widget.dart';
import 'package:frontend_aplication/pages/profile_page.dart';

class CollapsingAppbarWithTabsPage extends StatefulWidget {
  const CollapsingAppbarWithTabsPage({super.key});

  @override
  CollapsingAppbarWithTabsPageState createState() =>
      CollapsingAppbarWithTabsPageState();
}

class CollapsingAppbarWithTabsPageState
    extends State<CollapsingAppbarWithTabsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const CollapsingAppBar(),
            ];
          },
          body: TabBarView(
            children: [
              const ImagePickerWidget(),
              Center(child: Text("Breeds")),
              const ProfilePage(),
            ],
          ),
        ),
      ),
    );
  }
}
