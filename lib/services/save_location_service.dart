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
  }

  Future<Owner?> loadOwner() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonMap = jsonDecode(jsonString);
        return Owner(
          email: jsonMap['email'],
          lists: (jsonMap['lists'] as List).map((list) {
            return ListModel(
              name: list['name'],
              sharedWithEmails: List<String>.from(list['sharedWithEmails']),
              locations: (list['locations'] as List).map((location) {
                return Location(
                  name: location['name'],
                  latitude: location['latitude'],
                  longitude: location['longitude'],
                  photos: List<String>.from(location['photos']),
                );
              }).toList(),
            );
          }).toList(),
        );
      }
    } catch (e) {
      print('Error loading owner data: $e');
    }
    return null;
  }
}
