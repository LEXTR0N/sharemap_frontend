class Owner {
  List<ListModel> lists;

  Owner({required this.lists});

  Map<String, dynamic> toJson() => {
    'lists': lists.map((list) => list.toJson()).toList(),
  };

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      lists: (json['lists'] as List).map((list) {
        return ListModel.fromJson(list);
      }).toList(),
    );
  }
}

class ListModel {
  String name;
  List<Location> locations;

  ListModel({
    required this.name,
    required this.locations,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'locations': locations.map((location) => location.toJson()).toList(),
  };

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      name: json['name'],
      locations: (json['locations'] as List).map((location) {
        return Location.fromJson(location);
      }).toList(),
    );
  }
}

class Location {
  String name;
  double latitude;
  double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? json['properties']['capital'],
      latitude: (json['latitude'] ?? json['geometry']['coordinates'][1] as num).toDouble(),
      longitude: (json['longitude'] ?? json['geometry']['coordinates'][0] as num).toDouble(),
    );
  }
}





