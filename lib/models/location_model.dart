class LocationModel {
  final int? id;
  final String name;
  final List<String> photos; // List of photo paths (you might change this based on your storage strategy)
  final double latitude;
  final double longitude;
  final int listId;

  LocationModel({
    this.id,
    required this.name,
    this.photos = const [],
    required this.latitude,
    required this.longitude,
    required this.listId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photos': photos.join(','), // Store photos as a comma-separated string
      'latitude': latitude,
      'longitude': longitude,
      'listId': listId,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'],
      name: map['name'],
      photos: (map['photos'] as String?)?.split(',') ?? [],
      latitude: map['latitude'],
      longitude: map['longitude'],
      listId: map['listId'],
    );
  }
}