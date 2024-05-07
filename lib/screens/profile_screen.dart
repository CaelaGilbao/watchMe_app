import 'package:flutter/material.dart';
import 'package:watch_me/components/navigation_menu.dart';
import 'package:watch_me/functions/bottom_nav_bar_bloc.dart';
import 'package:watch_me/screens/welcome.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final BottomNavBarBloc _bottomNavBarBloc = BottomNavBarBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              // Handle sign out logic
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Welcome()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Profile Screen!'),
          ],
        ),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _bottomNavBarBloc.indexStream,
        builder: (context, snapshot) {
          return BottomNavBar(
            currentIndex: snapshot.data ?? 2,
            onTap: (index) {
              _bottomNavBarBloc.updateIndex(index);
              if (index == 0) {
                Navigator.pushReplacementNamed(context, 'home');
              } else if (index == 1) {
                Navigator.pushReplacementNamed(context, 'search');
              }
            },
          );
        },
      ),
    );
  }
}
