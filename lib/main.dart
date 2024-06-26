import 'package:flutter/material.dart';
import 'package:watch_me/auth/login.dart';
import 'package:watch_me/auth/register.dart';
import 'package:watch_me/auth/set_profile_picture_screen.dart';
import 'package:watch_me/auth/set_user_info_screen.dart';
import 'package:watch_me/firebase_options.dart';
import 'package:watch_me/functions/authFunction.dart';
import 'package:watch_me/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:watch_me/screens/profile_screen.dart';
import 'package:watch_me/screens/search_screen.dart';
import 'package:watch_me/screens/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthService(),
      routes: {
        'welcome': (context) => const Welcome(),
        'home': (context) => const HomeScreen(),
        'login': (context) => Login(),
        'register': (context) => const Register(),
        'search': (context) => SearchScreen(),
        'profile': (context) => ProfileScreen(),
        'setUserInfo': (context) => SetUserInfoScreen(),
        'setProfilePicture': (context) => SetProfilePictureScreen(),
      },
    );
  }
}
