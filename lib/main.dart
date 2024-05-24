import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sharemap_frontend/screens/home_screen.dart';
import 'package:sharemap_frontend/widgets/permission_handler_widget.dart';

Future<void> main() async {
  try {
    // Attempt to load the .env file
    await dotenv.load(fileName: "assets/.env");
    print(".env file loaded successfully");
  } catch (e) {
    // Handle the case where the .env file does not exist
    print("Could not load .env file: $e");
  }

  runApp(ShareMap());
}

class ShareMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareMap',

      // Location can be used if accepted the first time, but the app has to be restarted because geolocator throws an error on the first attempt.
      home: PermissionHandlerWidget(
        child: HomeScreen(), // Hier wird die HomeScreen-Klasse verwendet
      ),
    );
  }
}
