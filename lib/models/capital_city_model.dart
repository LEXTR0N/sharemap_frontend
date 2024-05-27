class CapitalCity {
  final String capital;
  final String country;

  CapitalCity({required this.capital, required this.country});

  factory CapitalCity.fromJson(Map<String, dynamic> json) {
    return CapitalCity(
      capital: json['properties']['capital'] as String,
      country: json['properties']['country'] as String,
    );
  }
}
