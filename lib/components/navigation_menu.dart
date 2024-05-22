import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bgColor = const Color(0xFF021B3A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      color: bgColor,
      height: 92, // Specify the height here
      width: MediaQuery.of(context).size.width, // Set full width
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: bgColor, // Set navigation bar color
        selectedItemColor: Colors.white, // Set selected item color
        unselectedItemColor: const Color(0xFFFC6736), // Set unselected item color
        iconSize: 35, // Set icon size
        // Adjust the padding between icons using SizedBox
        // Wrap each icon with SizedBox to add horizontal spacing
        items: [
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10), // Adjust padding as needed
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10), // Adjust padding as needed
              child: Icon(Icons.search),
            ),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10), // Adjust padding as needed
              child: Icon(Icons.person),
            ),
            label: 'Profile',
          ),
        ],
        // Customize label text style
        selectedLabelStyle: const TextStyle(
          fontSize: 14, // Set font size
          fontWeight: FontWeight.normal, // Set font weight
          fontFamily: 'Poppins', // Set font family
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14, // Set font size
          fontWeight: FontWeight.normal, // Set font weight
          fontFamily: 'Poppins', // Set font family
        ),
      ),
    );
  }
}
