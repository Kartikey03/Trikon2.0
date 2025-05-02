import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  bool _isSelectingImage = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _selectedYear;
  String? _selectedDepartment;
  String? _selectedBranch;
  String? _userId;
  String? _localProfileImagePath;
  File? _profileImageFile;

  // List of options for dropdowns
  final List<String> _years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  final List<String> _departments = ['CSE', 'ECE', 'EE', 'Bio Tech', 'B Pharma', 'MBA'];
  final List<String> _branches = ['Core', 'AIML', 'AI', 'CSIT', 'DS', 'CS', 'Other'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        _userId = currentUser.uid;

        // Set email from auth (cannot be changed)
        _emailController.text = currentUser.email ?? '';

        // Load local profile image path from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        _localProfileImagePath = prefs.getString('profile_image_${currentUser.uid}');
        if (_localProfileImagePath != null) {
          _profileImageFile = File(_localProfileImagePath!);
          if (!await _profileImageFile!.exists()) {
            _profileImageFile = null;
            _localProfileImagePath = null;
          }
        }

        // Get additional data from Realtime Database
        final snapshot = await FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(currentUser.uid)
            .get();

        if (snapshot.exists) {
          final userData = snapshot.value as Map<dynamic, dynamic>;

          setState(() {
            _nameController.text = userData['name'] ?? '';
            _phoneController.text = userData['phone'] ?? '';
            _selectedYear = userData['year'];
            _selectedDepartment = userData['department'];
            _selectedBranch = userData['branch'];
            _isLoading = false;
          });
        } else {
          // If no additional data, just use what we have from Auth
          _nameController.text = currentUser.displayName ?? '';
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // Not logged in - this shouldn't happen but handle anyway
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    if (!_isEditing) return;

    try {
      setState(() {
        _isSelectingImage = true;
      });

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image == null) {
        setState(() {
          _isSelectingImage = false;
        });
        return;
      }

      // Get the app's documents directory for storing the image
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${_userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(image.path).copy('${appDir.path}/$fileName');

      // Save the path to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_${_userId}', savedImage.path);

      setState(() {
        _localProfileImagePath = savedImage.path;
        _profileImageFile = savedImage;
        _isSelectingImage = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated')),
      );
    } catch (e) {
      setState(() {
        _isSelectingImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Save to Realtime Database
      await FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(_userId!)
          .update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'year': _selectedYear,
        'department': _selectedDepartment,
        'branch': _selectedBranch,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Update display name in Firebase Auth
      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        _nameController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  // TODO: Implement actual QR code generation based on user ID or other unique identifier
  void _shareQRCode() {
    // TODO: Implement sharing functionality for the QR code
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QR Code sharing will be implemented soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('My Profile'),
          backgroundColor: Colors.indigo.shade800,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Profile'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.indigo.shade800,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          if (_isSelectingImage)
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: const CircularProgressIndicator(),
                            )
                          else if (_profileImageFile != null)
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 57,
                                backgroundImage: FileImage(_profileImageFile!),
                              ),
                            )
                          else
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 57,
                                backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
                              ),
                            ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.indigo.shade800,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isEditing ? 'Edit Your Profile' : _nameController.text,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (!_isEditing)
                      Text(
                        _emailController.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.indigo.shade100,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Profile Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Information Section
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.indigo.shade800),
                                const SizedBox(width: 8),
                                const Text(
                                  'Personal Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            const SizedBox(height: 8),

                            // Full Name Field
                            _isEditing
                                ? TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            )
                                : _buildReadOnlyField('Full Name', _nameController.text),
                            const SizedBox(height: 16),

                            // Email Field (read-only)
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabled: false,
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                ),
                              ),
                              readOnly: true,
                            ),
                            const SizedBox(height: 16),

                            // Phone Number Field
                            _isEditing
                                ? TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                // Simple phone validation
                                if (!RegExp(r'^\d{10}$').hasMatch(value) &&
                                    !RegExp(r'^\+\d{1,3}\d{10}$').hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                                return null;
                              },
                            )
                                : _buildReadOnlyField('Phone Number', _phoneController.text),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Academic Information Section
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.school, color: Colors.indigo.shade800),
                                const SizedBox(width: 8),
                                const Text(
                                  'Academic Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            const SizedBox(height: 8),

                            // Year Dropdown
                            _isEditing
                                ? DropdownButtonFormField<String>(
                              value: _selectedYear,
                              decoration: InputDecoration(
                                labelText: 'Year',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: _years.map((String year) {
                                return DropdownMenuItem<String>(
                                  value: year,
                                  child: Text(year),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedYear = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your year';
                                }
                                return null;
                              },
                            )
                                : _buildReadOnlyField('Year', _selectedYear ?? 'Not specified'),
                            const SizedBox(height: 16),

                            // Department Dropdown
                            _isEditing
                                ? DropdownButtonFormField<String>(
                              value: _selectedDepartment,
                              decoration: InputDecoration(
                                labelText: 'Department',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: _departments.map((String department) {
                                return DropdownMenuItem<String>(
                                  value: department,
                                  child: Text(department),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDepartment = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your department';
                                }
                                return null;
                              },
                            )
                                : _buildReadOnlyField('Department', _selectedDepartment ?? 'Not specified'),
                            const SizedBox(height: 16),

                            // Branch Dropdown
                            _isEditing
                                ? DropdownButtonFormField<String>(
                              value: _selectedBranch,
                              decoration: InputDecoration(
                                labelText: 'Branch',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: _branches.map((String branch) {
                                return DropdownMenuItem<String>(
                                  value: branch,
                                  child: Text(branch),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedBranch = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your branch';
                                }
                                return null;
                              },
                            )
                                : _buildReadOnlyField('Branch', _selectedBranch ?? 'Not specified'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),



                    const SizedBox(height: 30),

                    // Action Buttons
                    if (_isEditing)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                });
                                // Reload original data
                                _loadUserProfile();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.shade800,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text('Save Changes'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create read-only fields with consistent style
  Widget _buildReadOnlyField(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          TextFormField(
            initialValue: value,
            enabled: false,
            decoration: InputDecoration(
              labelText: label,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            ),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}