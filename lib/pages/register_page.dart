import 'package:flutter/material.dart';
import 'package:frontend_aplication/services/auth_service.dart';
import 'package:intl/intl.dart';

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

  // Function to pick the birthdate
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
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }

  // Function to handle the registration process
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
        // Attempting registration through the AuthService
        final success = await AuthService.register(userData);

        if (mounted) {
          if (success) {
            Navigator.pop(context);
          } else {
            setState(() {
              _errorMessage = 'Registration failed. Please try again.';
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            // Check if the error contains "Email already registered"
            if (e.toString().contains("Email already registered")) {
              _errorMessage = 'The email is already registered. Please use a different email.';
            } else {
              _errorMessage = 'An error occurred: $e';
            }
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
              // Email field with validation
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
              // Password field with validation
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
              // First Name field with validation
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
              // Last Name field with validation
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
              // Birth Date field with date picker
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
              // Country field (optional)
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: "Country (Optional)"),
                maxLength: 30,
              ),
              const SizedBox(height: 16.0),
              // Display loading indicator or the register button
              if (_loading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _register,
                  child: const Text("Register"),
                ),
              const SizedBox(height: 8.0),
              // Error message display
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              // Login redirect link
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
