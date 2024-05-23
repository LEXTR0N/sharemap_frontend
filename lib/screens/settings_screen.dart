import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
      ),
      body: const Center(
        child: Text('Hier sind die Einstellungen und Accountdetails'),
      ),
    );
  }
}
