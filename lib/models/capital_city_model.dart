class CapitalCity {
  final String capital;
  final String country;
  final double latitude;
  final double longitude;

  CapitalCity({
    required this.capital,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory CapitalCity.fromJson(Map<String, dynamic> json) {
    return CapitalCity(
      capital: json['properties']['capital'] as String,
      country: json['properties']['country'] as String,
      latitude: json['geometry']['coordinates'][1].toDouble(),
      longitude: json['geometry']['coordinates'][0].toDouble(),
    );
  }
}
