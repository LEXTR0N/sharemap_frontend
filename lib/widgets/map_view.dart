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
  bool _mapInitialized = false; // Flag to check if the map has been centered initially

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() async {
    try {
      Position? position = await _locationService.getCurrentPosition();
      if (position != null) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _mapController.move(_currentLocation!, 13.0); // Move map to current location
          _mapInitialized = true;
        });
        print('Initial location: ${position.latitude}, ${position.longitude}');
      }
    } catch (error) {
      print('Error fetching initial location: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.maybeGet('TOMTOM_API_KEY');
    if (apiKey == null) {
      return Center(child: Text('API Key not found!'));
    }

    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentLocation ?? initialLocation,
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key={apiKey}",
            additionalOptions: {"apiKey": apiKey},
          ),
          MarkerLayer(
            markers: _buildMarkers(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentLocation != null) {
            _mapController.move(_currentLocation!, 13.0);
          }
        },
        child: Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          width: 80,
          height: 80,
          child: Icon(Icons.person_pin_circle, size: 40, color: Colors.blue),
        ),
    ];
  }
}
