import 'package:flutter/material.dart';
import 'package:sharemap_frontend/bloc/home_bloc.dart';

import '../../screens/settings_screen.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _homeBloc = HomeBloc();
  int _selectedIndex = -1; // Zustand für den ausgewählten Index

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // AppBar entfernen
      body: Container(
        color: Colors.blue, // Einfaches blaues Hintergrundwidget
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: _selectedIndex == 0
                      ? Colors.blue.withOpacity(0.7)
                      : Colors.white,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.location_on),
                    Text(
                      'Standort',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: _selectedIndex == 1
                      ? Colors.blue.withOpacity(0.7)
                      : Colors.white,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.menu),
                    Text(
                      'Liste',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Bedingung für die Anzeige der neuen Seite oder des Containers
      body: _selectedIndex == 1 ? ListScreen() : null,

      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            top: 40.0,
            right: 16.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: const Icon(Icons.account_circle),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
