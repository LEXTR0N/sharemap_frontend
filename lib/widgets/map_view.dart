// File: map_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  final LatLng initialLocation = LatLng(52.376372, 4.908066); // TomTom HQ

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.maybeGet('TOMTOM_API_KEY');
    if (apiKey == null) {
      // Handle the case where the API key is not found
      return Center(child: Text('API Key not found!'));
    }

    return FlutterMap(
      options: MapOptions(
        center: initialLocation,
        zoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
          "https://api.tomtom.com/map/1/tile/basic/main/"
              "{z}/{x}/{y}.png?key={apiKey}",
          additionalOptions: {"apiKey": apiKey},
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: initialLocation,
              width: 80,
              height: 80,
              child: FlutterLogo(),
            ),
          ],
        ),
      ],
    );
  }
}
