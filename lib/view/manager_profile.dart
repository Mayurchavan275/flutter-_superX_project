import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManagerProfilePage extends StatefulWidget {
  const ManagerProfilePage({super.key});

  @override
  State<ManagerProfilePage> createState() => _ManagerProfilePageState();
}

class _ManagerProfilePageState extends State<ManagerProfilePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController =
      TextEditingController(text: "John Anderson");
  final TextEditingController _emailController =
      TextEditingController(text: "john.anderson@company.com");
  final TextEditingController _phoneController =
      TextEditingController(text: "+91 9876543210");

  bool _isEditing = false;

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Toggle between view and edit mode
  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manager Profile"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _isEditing ? _pickImage : null,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage('assets/manager_profile.jpg')
                              as ImageProvider,
                      child: _isEditing
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  _isEditing
                      ? TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Text(
                          _nameController.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                  const SizedBox(height: 8),
                  const Text(
                    "Regional Manager",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),

                  // Email
                  _isEditing
                      ? TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                          ),
                        )
                      : ListTile(
                          leading:
                              const Icon(Icons.email, color: Colors.deepPurple),
                          title: Text(_emailController.text),
                        ),

                  const SizedBox(height: 10),

                  // Phone
                  _isEditing
                      ? TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: "Phone",
                            border: OutlineInputBorder(),
                          ),
                        )
                      : ListTile(
                          leading:
                              const Icon(Icons.phone, color: Colors.deepPurple),
                          title: Text(_phoneController.text),
                        ),

                  const SizedBox(height: 20),

                  // Save Button
                  if (_isEditing)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Profile updated successfully!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text("Save Changes"),
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
