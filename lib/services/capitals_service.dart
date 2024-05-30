import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';

class CapitalsService {
  Future<List<Location>> fetchEuropeanCapitals() async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/Ginden/capitals/master/europe.json'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) {
        return Location(
          name: data['properties']['capital'],
          latitude: (data['geometry']['coordinates'][1] as num).toDouble(),
          longitude: (data['geometry']['coordinates'][0] as num).toDouble(),
        );
      }).toList();
    } else {
      throw Exception('Failed to load capitals data');
    }
  }
}
