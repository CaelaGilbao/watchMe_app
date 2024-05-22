import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:watch_me/components/my_button.dart';

class SetProfilePictureScreen extends StatefulWidget {
  @override
  _SetProfilePictureScreenState createState() =>
      _SetProfilePictureScreenState();
}

class _SetProfilePictureScreenState extends State<SetProfilePictureScreen> {
  File? _imageFile;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveProfilePicture() async {
    if (user != null && _imageFile != null) {
      try {
        String? userId = user!.uid;
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users').child(userId);

        // Upload the image to Firebase Storage
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('$userId.jpg');
        UploadTask uploadTask = storageRef.putFile(_imageFile!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        // Update the user's photoURL in Realtime Database
        await userRef.update({'photoURL': downloadURL});

        // Navigate to the home screen
        Navigator.pushReplacementNamed(context, 'home');
      } catch (e) {
        print('Error uploading profile picture: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = const Color(0xFF021B3A);
    Color textColor = const Color(0xFFFC6736);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    'Select a Profile Picture',
                    style: TextStyle(
                      color: textColor,
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Spacer to align the title to center
                  SizedBox(width: 20),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : AssetImage('assets/images/default_profile.jpg')
                                  as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 20),
                      MyButton(
                        onTap: _pickImage,
                        text: 'Select Profile Picture',
                      ),
                      SizedBox(height: 20),
                      MyButton(
                        onTap: _saveProfilePicture,
                        text: 'Save and Continue',
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'home');
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: textColor,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
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
