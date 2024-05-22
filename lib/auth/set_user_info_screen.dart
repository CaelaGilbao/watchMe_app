// set_user_info_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:watch_me/components/my_textfield.dart'; // Assuming you have this component

class SetUserInfoScreen extends StatefulWidget {
  @override
  _SetUserInfoScreenState createState() => _SetUserInfoScreenState();
}

class _SetUserInfoScreenState extends State<SetUserInfoScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _birthdayController = TextEditingController();
  String? _selectedGender;
  final user = FirebaseAuth.instance.currentUser;

  void _selectBirthday() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _saveUserInfo() async {
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(user!.uid);
      await userRef.set({
        'name': _nameController.text,
        'age': _ageController.text,
        'birthday': _birthdayController.text,
        'gender': _selectedGender,
        'email': user!.email,
      });
      Navigator.pushReplacementNamed(context, 'setProfilePicture');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = const Color(0xFF021B3A);
    Color textColor = const Color(0xFFFC6736);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                    'Fill in your details',
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
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Name',
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            MyTextField(
              controller: _nameController,
              hintText: 'Name',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Age',
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            MyTextField(
              controller: _ageController,
              hintText: 'Age',
              obscureText: false,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Birthday',
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: _birthdayController,
                    hintText: 'MM-DD-YYYY',
                    obscureText: false,
                    enabled: true, // Disable typing
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: textColor),
                  onPressed: _selectBirthday,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Gender',
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            DropdownButtonFormField<String>(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 30,
              ),
              style: const TextStyle(color: Colors.white),
              value: _selectedGender,
              decoration: InputDecoration(
                hintText: 'Select Gender',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF24528A),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: textColor,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return <String>['Male', 'Female', 'Secret']
                    .map<Widget>((String value) {
                  return Text(
                    value,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15),
                  );
                }).toList();
              },
              items: <String>['Male', 'Female', 'Secret']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: textColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                  ),
                ),
                onPressed: _saveUserInfo,
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
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
