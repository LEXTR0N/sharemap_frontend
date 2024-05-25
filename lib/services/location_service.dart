import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  // Stream für den aktuellen Standort
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream();
  }
}
