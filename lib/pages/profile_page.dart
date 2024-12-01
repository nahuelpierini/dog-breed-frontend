import 'package:flutter/material.dart';
import 'package:frontend_aplication/pages/edit_dog_page.dart';
import 'package:frontend_aplication/services/user_service.dart'; // Asegúrate de crear este servicio
import 'package:frontend_aplication/models/user.dart'; // Asegúrate de crear este modelo
import 'package:frontend_aplication/models/dog.dart';
import 'package:frontend_aplication/services/auth_service.dart'; // Importa el AuthService para el logout
import 'package:frontend_aplication/pages/login_page.dart'; // Asegúrate de tener una página de login
import 'package:frontend_aplication/pages/edit_profile_page.dart'; // Importa la página de edición del perfil


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user; // Permite valores nulos
  List<Dog> _dogs = [];
  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus(); // Verificar si hay token
    _fetchProfileData();
  }

  Future<void> _checkAuthStatus() async {
    final token = await AuthService.getToken();
    if (token == null) {
      // Si no hay token, redirigir al LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<void> _fetchProfileData() async {
    try {
      final userData = await UserService.getUserProfile();
      final dogsData = await UserService.getUserDogs();
      setState(() {
        _user = userData; // Puede ser null si no hay datos
        _dogs = dogsData;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching profile data: $e';
        _loading = false;
      });
    }
  }

  Future<void> _logout() async {
    await AuthService.logout(); // Llamamos al logout del AuthService
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // Redirigimos al LoginPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), // Icono de edición
            onPressed: () async {
              if (_user != null) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(user: _user!),
                  ),
                );

                // Si se actualizó el perfil, refresca los datos
                if (result == true) {
                  _fetchProfileData();
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app), // Icono de logout
            onPressed: _logout, // Llama al método _logout cuando se presione
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : Column(
                  children: [
                    _user != null
                        ? ListTile(
                            title: Text('${_user!.firstName} ${_user!.lastName}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
                              children: [
                                Text(_user!.email),
                                Text(_user!.country ?? " "), // Controlamos valores nulos
                                Text(_user!.birthDate ?? " ") 
                              ],
                            ),
                          )
                      : const Text('No user data available'),
                    const Divider(),
                    Expanded(
                      child: _dogs.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('No dogs registered'),
                                ElevatedButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditDogPage(),
                                      ),
                                    );

                                    // Si se agregó un perro, actualiza la lista
                                    if (result == true) {
                                      _fetchProfileData();
                                    }
                                  },
                                  child: const Text('Add a Dog'),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: _dogs.length,
                              itemBuilder: (context, index) {
                                final dog = _dogs[index];
                                return ListTile(
                                  title: Text(dog.name),
                                  subtitle: Text('${dog.breed}, ${dog.age} years old'),
                                  leading: dog.imageUrl != null && dog.imageUrl!.isNotEmpty
                                      ? Image.network(dog.imageUrl!)  // Si hay URL de imagen, la carga
                                      : const Icon(                   // Si no hay URL, muestra un ícono
                                          Icons.image,
                                          size: 50.0,
                                          color: Colors.grey,
                                        ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      // Abre la página de edición
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditDogPage(dog: dog),
                                        ),
                                      );

                                      // Refresca los datos si se actualizó algo
                                      if (result == true) {
                                        _fetchProfileData();
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
