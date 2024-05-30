class CapitalLocation {
  final String name;
  final double latitude;
  final double longitude;

  CapitalLocation({required this.name, required this.latitude, required this.longitude});

  factory CapitalLocation.fromJson(Map<String, dynamic> json) {
    return CapitalLocation(
      name: json['capital'],
      latitude: json['geometry']['coordinates'][1],
      longitude: json['geometry']['coordinates'][0],
    );
  }
}
