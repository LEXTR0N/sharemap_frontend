import 'package:flutter/foundation.dart';
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

import 'bloc/home_screen/home_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    await dotenv.load(fileName: "assets/.env");
    if (kDebugMode) {
      print(".env file loaded successfully");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Could not load .env file: $e");
    }
  }

  LocationService locationService = LocationService();
  Position? position = await locationService.getCurrentPosition();
  if (position != null) {
    if (kDebugMode) {
      print('Current Position: ${position.latitude}, ${position.longitude}');
    }
  } else {
    if (kDebugMode) {
      print('Failed to get current position');
    }
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const ShareMap(),
    ),
  );
}

class ShareMap extends StatelessWidget {
  const ShareMap({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'ShareMap',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: PermissionHandlerWidget(
        child: BlocProvider(
          create: (context) => HomeBloc(),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
