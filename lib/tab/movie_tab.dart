import 'package:flutter/material.dart';

class MovieTab extends StatelessWidget {
  const MovieTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Text(
          'Movies',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
