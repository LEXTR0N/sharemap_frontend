import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:sharemap_frontend/bloc/home_bloc.dart';
import 'package:sharemap_frontend/bloc/home_event.dart';
import 'package:sharemap_frontend/bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _homeBloc = HomeBloc();

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Hier Aktion für den Drawer-ListTile 1 definieren
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Hier Aktion für den Drawer-ListTile 2 definieren
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.blue, // Einfaches blaues Hintergrundwidget
      ),
    );
  }
}
