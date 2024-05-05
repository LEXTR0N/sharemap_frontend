import 'package:flutter/material.dart';
import 'package:sharemap_frontend/presentation/screens/home_screen.dart';

void main() {
  runApp(ShareMap());
}

class ShareMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareMap',
      home: HomeScreen(), // Hier wird die HomeScreen-Klasse verwendet
    );
  }
}
