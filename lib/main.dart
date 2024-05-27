import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sharemap_frontend/screens/home_screen.dart';
import 'package:sharemap_frontend/widgets/permission_handler_widget.dart';

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

  runApp(ShareMap());
}

class ShareMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareMap',
      home: PermissionHandlerWidget(
        child: HomeScreen(), // HomeScreen is shown if permission is granted
      ),
    );
  }
}
