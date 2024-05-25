import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final LatLng initialLocation = LatLng(37.4219983, -122.084);
  final LocationService _locationService = LocationService();
  LatLng? _currentLocation; // Store current location
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _locationService.getPositionStream().listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentLocation!, 13.0); // Move map to current location
      });
      print('Current location: ${position.latitude}, ${position.longitude}');
    });
    // Initial location fetch
    _locationService.getCurrentPosition().then((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentLocation!, 13.0); // Move map to current location
      });
      print('Initial location: ${position.latitude}, ${position.longitude}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.maybeGet('TOMTOM_API_KEY');
    if (apiKey == null) {
      return Center(child: Text('API Key not found!'));
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _currentLocation ?? initialLocation,
        // Center on current location if available
        zoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
              "{z}/{x}/{y}.png?key={apiKey}",
          additionalOptions: {"apiKey": apiKey},
        ),
        MarkerLayer(
          markers: _buildMarkers(),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers() {
    return [
      Marker(
        point: initialLocation,
        width: 80,
        height: 80,
        child: FlutterLogo(),
      ),
      if (_currentLocation != null)
        Marker(
          point: _currentLocation!,
          // Use current location or fallback
          width: 80,
          height: 80,
          child: Icon(Icons.person_pin_circle,
              size: 40, color: Colors.blue), // Customize marker
        ),
    ];
  }
}

