import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // Return null if permission is denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null; // Return null if permission is permanently denied
    }

    Position position = await Geolocator.getCurrentPosition();
    if (kDebugMode) {
      print('Current POSITION: ${position.latitude}, ${position.longitude}');
    }
    return position;
  }

  Stream<Position?> getPositionStream() {
    return Geolocator.getPositionStream().handleError((error) {
      if (kDebugMode) {
        print('Location stream error: $error');
      }
      return null; // Return null on error
    });
  }
}
