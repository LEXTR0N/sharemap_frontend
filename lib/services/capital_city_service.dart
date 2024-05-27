import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/capital_city_model.dart';  // Ensure this import points to the correct model

class CapitalCityService {
  final String url = "https://raw.githubusercontent.com/Ginden/capitals/master/europe.json";

  Future<List<CapitalCity>> fetchCapitalCities() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CapitalCity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load capital cities');
    }
  }
}
