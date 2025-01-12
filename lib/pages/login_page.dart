import 'package:flutter/material.dart';
import 'package:frontend_aplication/pages/home_page.dart';
import 'package:frontend_aplication/services/auth_service.dart';
import 'package:frontend_aplication/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String _errorMessage = '';

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
            _errorMessage = 'Login failed. Please check your credentials.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An error occurred: $e';
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
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            if (_loading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _login,
                child: const Text("Login"),
              ),
            const SizedBox(height: 8.0),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
