import 'package:flutter/material.dart';
import 'package:frontend_aplication/widgets/collapsing_appbar.dart';
import 'package:frontend_aplication/widgets/image_picker_widget.dart';
import 'package:frontend_aplication/pages/profile_page.dart'; // Importa tu nueva página de perfil


class CollapsingAppbarWithTabsPage extends StatefulWidget {
  const CollapsingAppbarWithTabsPage({Key? key}) : super(key: key);

  @override
  _CollapsingAppbarWithTabsPageState createState() => _CollapsingAppbarWithTabsPageState();
}

class _CollapsingAppbarWithTabsPageState extends State<CollapsingAppbarWithTabsPage> {
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
              const ImagePickerWidget(), // Widget para seleccionar imágenes
              Center(child: Text("Breeds")), // Aquí podrías poner más funcionalidades
              const ProfilePage(), // Cambiado para incluir el ProfilePage
            ],
          ),
        ),
      ),
    );
  }
}
