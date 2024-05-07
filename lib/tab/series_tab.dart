import 'package:flutter/material.dart';

class SeriesTab extends StatelessWidget {
  const SeriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Text(
          'Series',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
