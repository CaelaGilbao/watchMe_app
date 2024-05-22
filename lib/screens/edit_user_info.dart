import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final String? name;
  final String? age;
  final String? birthday;
  final String? gender;
  final String? bio;
  final String? profileImage;
  final Function(String?, String?, String?, String?, String?, File?) onSave;

  const EditProfileScreen({
    Key? key,
    required this.name,
    required this.age,
    required this.birthday,
    required this.gender,
    required this.bio,
    required this.profileImage,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _birthdayController;
  late TextEditingController _bioController;

  File? _profileImage;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _ageController = TextEditingController(text: widget.age);
    _birthdayController = TextEditingController(text: widget.birthday);
    _bioController = TextEditingController(text: widget.bio);
    _selectedGender = widget.gender;

    // Initialize _profileImage with null since the initial profile image is a URL
    _profileImage = null;
  }

  Future<void> _pickProfileImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 15,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 15,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserProfile(
    String name,
    String age,
    String birthday,
    String gender,
    String bio,
    File? profileImage,
  ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users').child(user.uid);

        Map<String, dynamic> userData = {
          'name': name,
          'age': age,
          'birthday': birthday,
          'gender': gender,
          'bio': bio,
        };

        // Upload profile image if available
        if (profileImage != null) {
          String imageUrl = await _uploadProfileImage(user.uid, profileImage);
          userData['photoURL'] = imageUrl;
        }

        await userRef.update(userData);

        // Optionally, update the user's displayName
        await user.updateDisplayName(name);
      }
    } catch (e) {
      print('Error updating user profile: $e');
      // Handle error
    }
  }

  Future<String> _uploadProfileImage(String userId, File imageFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      // Handle error
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = const Color(0xFFFC6736);
    Color bgColor = const Color(0xFF021B3A);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Color(0xFFFC6736),
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white, // Adjust border color as needed
                        width: 2, // Adjust border width as needed
                      ),
                    ),
                    child: _profileImage != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(_profileImage!),
                          )
                        : (widget.profileImage != null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    NetworkImage(widget.profileImage!),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                backgroundColor: Color(0xFF24528A),
                                child: Icon(Icons.person,
                                    color: Colors.white, size: 50),
                              )),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.camera_alt, color: textColor),
                    label: Text(
                      'Change Profile Picture',
                      style: TextStyle(color: textColor),
                    ),
                    onPressed: _pickProfileImage,
                  ),
                ],
              ),
            ),
            _buildTextField(
              'Name',
              _nameController,
            ),
            _buildTextField('Age', _ageController),
            _buildTextField('Birthday', _birthdayController),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: const TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                dropdownColor: const Color(
                    0xFF021B3A), // Background color for the dropdown
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: <String>['Male', 'Female', 'Secret']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: _selectedGender == value
                            ? Colors.white
                            : Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            _buildTextField('Bio', _bioController, maxLines: 3),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
              child: Container(
                width: 500, // Adjust the width as needed
                height: 50, // Adjust the height as needed
                child: ElevatedButton(
                  onPressed: () async {
                    await _updateUserProfile(
                      _nameController.text,
                      _ageController.text,
                      _birthdayController.text,
                      _selectedGender ?? '',
                      _bioController.text,
                      _profileImage,
                    );
                    widget.onSave(
                      _nameController.text,
                      _ageController.text,
                      _birthdayController.text,
                      _selectedGender,
                      _bioController.text,
                      _profileImage,
                    );
                    Navigator.pop(context);
                  },
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(textColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
