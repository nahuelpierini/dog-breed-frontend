import 'package:flutter/material.dart';
import 'package:frontend_aplication/services/auth_service.dart';
import 'package:intl/intl.dart'; // Asegúrate de importar intl

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _loading = false;
  String _errorMessage = '';
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

  // Función para seleccionar la fecha de nacimiento
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!); // Aquí se usa DateFormat
      });
    }
  }

  // Función para registrar al usuario
  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });

      final userData = {
        'email': _emailController.text,
        'password': _passwordController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'birth_date': _birthDateController.text,
        'country': _countryController.text,
      };

      try {
        final success = await AuthService.register(userData);

        if (success) {
          Navigator.pop(context); // Redirigir si el registro es exitoso
        } else {
          setState(() {
            _errorMessage = 'Registration failed. Please try again.'; // Manejo de error genérico
          });
        }
      } catch (e) {
        setState(() {
          // Verificar si el error contiene "Email already registered"
          if (e.toString().contains("Email already registered")) {
            _errorMessage = 'The email is already registered. Please use a different email.';
          } else {
            _errorMessage = 'An error occurred: $e'; // Error genérico
          }
        });
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              // Campo de Contraseña
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 3 || value.length > 10) {
                    return 'Password must be between 3 and 10 characters';
                  }
                  return null;
                },
              ),
              // Campo de Nombre
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
                maxLength: 30,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First Name is required';
                  }
                  return null;
                },
              ),
              // Campo de Apellido
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
                maxLength: 30,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last Name is required';
                  }
                  return null;
                },
              ),
              // Selección de Fecha de Nacimiento
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(labelText: "Birth Date"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Birth Date is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // Campo de País
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: "Country (Optional)"),
                maxLength: 30,
              ),
              const SizedBox(height: 16.0),
              // Mostrar el cargando o el botón de registro
              if (_loading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _register,
                  child: const Text("Register"),
                ),
              const SizedBox(height: 8.0),
              // Mensaje de error si ocurre
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              // Enlace para ir a la página de Login
              TextButton(
                onPressed: () {
                  Navigator.pop(context); 
                },
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
