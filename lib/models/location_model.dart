class LocationModel {
  final int? id;
  final int listId;
  final String name;
  final double latitude;
  final double longitude;
  final List<String> photoPaths;

  LocationModel({
    this.id,
    required this.listId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.photoPaths = const [],
  });

  // Convert a LocationModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listId': listId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      // We'll store photoPaths separately in the Photos table
    };
  }

  // Create a LocationModel from a Map
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'],
      listId: map['listId'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
