import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watch_me/components/my_button.dart';
import 'package:watch_me/components/my_textfield.dart';
import 'package:watch_me/components/square_tile.dart';

// Your Register class definition...

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  void signUpUser(BuildContext context) async {
    // Reset errors
    setState(() {
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    try {
      if (passwordController.text != confirmPasswordController.text) {
        setState(() {
          confirmPasswordError = 'Passwords do not match';
        });
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // User signed up successfully
      print('User signed up: ${userCredential.user!.email}');

      // Navigate to SetUserInfoScreen
      Navigator.pushReplacementNamed(context, 'setUserInfo');
    } catch (e) {
      // An error occurred while signing up the user
      String errorMessage = 'An error occurred';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak';
            setState(() {
              passwordError = errorMessage;
            });
            break;
          case 'email-already-in-use':
            errorMessage = 'The account already exists for that email';
            setState(() {
              emailError = errorMessage;
            });
            break;
          default:
            errorMessage = 'Error: ${e.message}';
            break;
        }
      }
    }
  }

  void navigateToUserInfo(BuildContext context) {
    Navigator.pushNamed(context, 'setUserInfo');
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = const Color(0xFF021B3A);
    Color textColor = const Color(0xFFFC6736);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Create an account so you can explore all the movies and series that you may like',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 40),
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
              errorText: emailError,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
              showSuffixIcon: true,
              errorText: passwordError,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm password',
              obscureText: true,
              showSuffixIcon: true,
              errorText: confirmPasswordError,
            ),
            const SizedBox(
              height: 30,
            ),
            MyButton(
              onTap: () => signUpUser(context),
              text: 'Sign Up',
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => navigateToUserInfo(context),
              child: Container(
                padding: const EdgeInsets.all(13),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Already have an account',
                    style: TextStyle(
                      color: bgColor,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 90,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareTile(imagePath: 'assets/images/google_logo.png'),
                SizedBox(width: 10),
                SquareTile(imagePath: 'assets/images/fb_logo.png'),
                SizedBox(width: 10),
                SquareTile(imagePath: 'assets/images/ios_logo.png')
              ],
            )
          ],
        ),
      ),
    );
  }
}
