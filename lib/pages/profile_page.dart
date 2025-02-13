import 'package:flutter/material.dart';
import 'package:frontend_aplication/pages/edit_dog_page.dart';
import 'package:frontend_aplication/services/user_service.dart';
import 'package:frontend_aplication/models/user.dart';
import 'package:frontend_aplication/models/dog.dart';
import 'package:frontend_aplication/services/auth_service.dart';
import 'package:frontend_aplication/pages/login_page.dart';
import 'package:frontend_aplication/pages/edit_profile_page.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  User? _user;
  List<Dog> _dogs = [];
  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _fetchProfileData();
  }

  // Function to format the date
  String formatDate(String dateStr) {
    try {
      final DateFormat inputFormat =
          DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
      final DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      final date = inputFormat.parse(dateStr);
      return outputFormat.format(date);
    } catch (e) {
      return "Fecha inválida: $e";
    }
  }

  // Check authentication status
  Future<void> _checkAuthStatus() async {
    final token = await AuthService.getToken();
    if (token == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  // Obtains user and dog profile data
  Future<void> _fetchProfileData() async {
    try {
      final userData = await UserService.getUserProfile();
      final dogsData = await UserService.getUserDogs();
      setState(() {
        _user = userData;
        _dogs = dogsData;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al obtener datos del servidor: $e';
        _loading = false;
      });
    }
  }

  // Logout session
  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 177, 12, 0),
            ),
            onPressed: _logout,
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
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        bool isSmallScreen = constraints.maxWidth < 600;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 400),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${_user!.firstName} ${_user!.lastName}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _user!.email,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _user!.country ??
                                              "No hay info del país",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          formatDate(_user!.birthDate ?? " "),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (_user != null) {
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfilePage(
                                                          user: _user!),
                                                ),
                                              );

                                              // Refresh profile data if updated
                                              if (result == true) {
                                                _fetchProfileData();
                                              }
                                            }
                                          },
                                          child: const Text("Editar Perfil"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Dog info and editing section
                            isSmallScreen
                                ? Column(
                                    children: [
                                      _buildDogSection(),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(child: _buildDogSection()),
                                    ],
                                  ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
    );
  }

  Widget _buildDogSection() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 210),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: const Text(
                    'Doggy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _dogs.isEmpty
                    ? Column(
                        children: [
                          const Text(
                            'No hay perros registrados',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDogPage(),
                                ),
                              );

                              // If a dog was added, refresh the list
                              if (result == true) {
                                _fetchProfileData();
                              }
                            },
                            child: const Text('Agregar perrito'),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _dogs.map((dog) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                dog.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                dog.breed,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Edad: ${dog.age}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              dog.imageUrl.isNotEmpty
                                  ? Image.network(dog.imageUrl)
                                  : const Icon(Icons.pets, size: 50),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditDogPage(dog: dog),
                                      ),
                                    );

                                    if (result == true) {
                                      _fetchProfileData();
                                    }
                                  },
                                  child: const Text('Editar Info'),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
