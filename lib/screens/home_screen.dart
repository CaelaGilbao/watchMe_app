import 'package:flutter/material.dart';
import 'package:watch_me/components/navigation_menu.dart';
import 'package:watch_me/functions/bottom_nav_bar_bloc.dart';
import 'package:watch_me/tab/movie_tab.dart';
import 'package:watch_me/tab/series_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BottomNavBarBloc _bottomNavBarBloc = BottomNavBarBloc();
  int _selectedIndex = 0; // Variable to keep track of the selected tab index

  @override
  Widget build(BuildContext context) {
    Color textColor = Color(0xFFFC6736);
    Color bgColor = Color(0xFF021B3A);
    Color unselectedTab = Color(0xfffff);

    return Scaffold(
      body: Container(
        color: bgColor,
        child: Column(
          children: [
            SizedBox(height: 40), // Top margin
            // Tab Header
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30, // Reduced vertical padding
              ),
              child: Text(
                'watchMe', // Tab Header
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Poppins',
                  fontSize: 20,
                ),
              ),
            ),
            // Tab Body
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10), // Adjusted vertical padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0; // Set index for Movies tab
                      });
                    },
                    child: Container(
                      width: 125, // Set tab container width
                      height: 30, // Set tab container height
                      padding: EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0 ? textColor : unselectedTab,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Movies', // Tab Header
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1; // Set index for Series tab
                      });
                    },
                    child: Container(
                      width: 125, // Set tab container width
                      height: 30, // Set tab container height
                      padding: EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1 ? textColor : unselectedTab,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Series', // Tab Header
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _selectedIndex == 0 ? MovieTab() : SeriesTab(), // Tab Body
            ),
          ],
        ),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _bottomNavBarBloc.indexStream,
        builder: (context, snapshot) {
          return BottomNavBar(
            currentIndex: snapshot.data ?? 0,
            onTap: (index) {
              _bottomNavBarBloc.updateIndex(index);
              if (index == 1) {
                Navigator.pushReplacementNamed(context, 'search');
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
