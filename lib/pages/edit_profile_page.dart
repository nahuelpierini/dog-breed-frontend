import 'package:flutter/material.dart';
import 'package:frontend_aplication/models/user.dart';
import 'package:frontend_aplication/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';

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
              const SnackBar(content: Text('Error al actualizar el perfil')),
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

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _countryController.text = country.name;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0, left: 16.0, right: 16.0),
            child: Container(
              width: MediaQuery.of(context).size.width > 600
                  ? 500
                  : MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(16.0),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Editar Perfil",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) =>
                          value!.isEmpty ? 'Nombre obligatorio' : null,
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Apellido'),
                      validator: (value) =>
                          value!.isEmpty ? 'Apellido obligatorio' : null,
                    ),
                    TextFormField(
                      controller: _birthDateController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Nacimiento',
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

                        setState(() {
                          _birthDateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate!);
                        });
                      },
                      validator: (value) => value!.isEmpty
                          ? 'Fecha de Nacimiento obligatoria'
                          : null,
                    ),
                    GestureDetector(
                      onTap: _selectCountry,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _countryController,
                          decoration: const InputDecoration(
                            labelText: 'País',
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'País oblogatorio' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
