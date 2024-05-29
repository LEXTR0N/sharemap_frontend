import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sharemap_frontend/screens/home_screen.dart';
import 'package:sharemap_frontend/services/location_service.dart';
import 'package:sharemap_frontend/widgets/permission_handler_widget.dart';
import 'package:sharemap_frontend/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    // Attempt to load the .env file
    await dotenv.load(fileName: "assets/.env");
    print(".env file loaded successfully");
  } catch (e) {
    // Handle the case where the .env file does not exist
    print("Could not load .env file: $e");
  }

  // Print the current location
  LocationService locationService = LocationService();
  Position? position = await locationService.getCurrentPosition();
  if (position != null) {
    print('Current Position: ${position.latitude}, ${position.longitude}');
  } else {
    print('Failed to get current position');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: ShareMap(),
    ),
  );
}

class ShareMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'ShareMap',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: PermissionHandlerWidget(
        child: HomeScreen(), // HomeScreen is shown if permission is granted
      ),
    );
  }
}
