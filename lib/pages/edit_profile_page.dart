import 'package:flutter/material.dart';
import 'package:frontend_aplication/models/user.dart';
import 'package:frontend_aplication/services/user_service.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthDateController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);

    _birthDateController = TextEditingController(
      text: formatDate(widget.user.birthDate ?? ''),
    );

    _countryController = TextEditingController(text: widget.user.country);
  }

  String formatDate(String dateStr) {
    if (dateStr.isEmpty) {
      return '';
    }

    try {
      final DateFormat inputFormat =
          DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
      final DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      final date = inputFormat.parse(dateStr);
      return outputFormat.format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'birth_date': _birthDateController.text,
        'country': _countryController.text,
      };

      try {
        final response = await UserService.updateUserProfile(updatedUser);
        if (response) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update profile')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value!.isEmpty ? 'First Name is required' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Last Name is required' : null,
              ),
              TextFormField(
                controller: _birthDateController,
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _birthDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Birth Date is required' : null,
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (value) =>
                    value!.isEmpty ? 'Country is required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
