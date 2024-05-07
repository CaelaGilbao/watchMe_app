import 'package:flutter/material.dart';
import 'package:watch_me/components/navigation_menu.dart';
import 'package:watch_me/functions/bottom_nav_bar_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final BottomNavBarBloc _bottomNavBarBloc = BottomNavBarBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Search'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Search Screen!'),
          ],
        ),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _bottomNavBarBloc.indexStream,
        builder: (context, snapshot) {
          return BottomNavBar(
            currentIndex: snapshot.data ?? 1,
            onTap: (index) {
              _bottomNavBarBloc.updateIndex(index);
              if (index == 0) {
                Navigator.pushReplacementNamed(context, 'home');
              } else if (index == 2) {
                Navigator.pushReplacementNamed(context, 'profile');
              }
            },
          );
        },
      ),
    );
  }
}
