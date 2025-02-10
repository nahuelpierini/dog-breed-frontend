import 'package:flutter/material.dart';
import 'package:frontend_aplication/services/auth_service.dart';
import 'package:frontend_aplication/pages/home_page.dart';
import 'package:frontend_aplication/pages/register_page.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String _errorMessage = '';
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // Check authentication status and redirect if a token is found
  Future<void> _checkAuthStatus() async {
    final token = await AuthService.getToken();

    if (token != null && mounted) {
      // Redirect to HomePage if a token is found
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  // Login function to handle user authentication
  void _login() async {
    setState(() {
      _loading = true;
    });

    try {
      final success = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        // Redirect to HomePage if login is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        if (mounted) {
          setState(() {
            _errorMessage =
                'Fallo en el inicio de sesión. Verifique sus credenciales.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ocurrió un error: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth > 600 ? 400 : screenWidth * 0.8;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: containerWidth,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "INICIAR SESIÓN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: "Contraseña",
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            if (_loading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _login,
                child: const Text("Iniciar sesión"),
              ),
            const SizedBox(height: 8.0),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text("No tiene cuenta? Registrese",
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ),
          ],
        ),
      ),
    );
  }
}
