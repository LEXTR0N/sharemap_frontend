import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/location_model.dart';

class SaveLocationService {
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/locations.json';
  }

  Future<void> saveOwner(Owner owner) async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    final jsonString = jsonEncode(owner.toJson());
    await file.writeAsString(jsonString);
    print('Location successfully saved!');
  }

  Future<Owner?> loadOwner() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonMap = jsonDecode(jsonString);
        return Owner.fromJson(jsonMap);
      }
    } catch (e) {
      print('Error loading owner data: $e');
    }
    return null;
  }
}
