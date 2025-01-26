import 'package:flutter/material.dart';
import 'package:frontend_aplication/models/dog.dart';
import 'package:frontend_aplication/services/dog_service.dart';

class EditDogPage extends StatefulWidget {
  final Dog? dog;

  const EditDogPage({super.key, this.dog});

  @override
  EditDogPageState createState() => EditDogPageState();
}

class EditDogPageState extends State<EditDogPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.dog != null) {
      _nameController.text = widget.dog!.name;
      _breedController.text = widget.dog!.breed;
      _ageController.text = widget.dog!.age.toString();
    }
  }

  Future<void> _saveDog() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      final dogData = {
        'name': _nameController.text,
        'breed': _breedController.text,
        'age': _ageController.text,
      };

      if (widget.dog != null) {
        await DogService.updateDog(widget.dog!.id, dogData);
      } else {
        await DogService.createDog(dogData);
      }

      // Ensure the widget is still mounted before navigating or showing SnackBar
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Ensure the widget is still mounted before showing the SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      // Ensure the widget is still mounted before updating loading state
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(''),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 200.0, left: 16.0, right: 16.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            widget.dog != null ? 'Edit Dog' : 'Add Dog',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _breedController,
                                decoration:
                                    const InputDecoration(labelText: 'Breed'),
                              ),
                              TextFormField(
                                controller: _ageController,
                                decoration:
                                    const InputDecoration(labelText: 'Age'),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _saveDog,
                                  child: Text(widget.dog != null
                                      ? 'Update Dog'
                                      : 'Add Dog'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
