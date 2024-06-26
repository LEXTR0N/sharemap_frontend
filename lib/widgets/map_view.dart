import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/location_service.dart';

class MapView extends StatefulWidget {
  final LatLng? selectedLocation;

  const MapView({super.key, this.selectedLocation});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final LatLng initialLocation = const LatLng(37.4219983, -122.084);
  final LocationService _locationService = LocationService();
  LatLng? _currentLocation; // Store current location
  final MapController _mapController = MapController();
  bool _mapInitialized = false; // Flag to check if the map has been centered initially

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() async {
    try {
      var position = await _locationService.getCurrentPosition();
      if (position != null) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          if (!_mapInitialized) {
            _mapController.move(_currentLocation!, 13.0); // Move map to current location
            _mapInitialized = true;
          }
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching initial location: $error');
      }
    }
  }

  @override
  void didUpdateWidget(MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLocation != null && widget.selectedLocation != oldWidget.selectedLocation) {
      _mapController.move(widget.selectedLocation!, 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.maybeGet('TOMTOM_API_KEY');
    if (apiKey == null) {
      return const Center(child: Text('API Key not found!'));
    }

    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode ? const Color(0xFF212121) : Colors.white;
    final tileLayerUrl = themeProvider.isDarkMode
        ? "https://api.tomtom.com/map/1/tile/basic/night/{z}/{x}/{y}.png?key=$apiKey"
        : "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey";

    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentLocation ?? initialLocation,
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: tileLayerUrl,
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
        backgroundColor: backgroundColor,
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[
      if (_currentLocation != null)
        Marker(
          point: _currentLocation!,
          width: 80,
          height: 80,
          child: const Icon(Icons.person_pin_circle, size: 40, color: Colors.blue),
        ),
      if (widget.selectedLocation != null)
        Marker(
          point: widget.selectedLocation!,
          width: 80,
          height: 80,
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
    ];
    return markers;
  }
}
