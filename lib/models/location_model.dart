class Location {
  String name;
  double latitude;
  double longitude;
  List<String> photos;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.photos,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'photos': photos,
  };
}

class ListModel {
  String name;
  List<String> sharedWithEmails;
  List<Location> locations;

  ListModel({
    required this.name,
    required this.sharedWithEmails,
    required this.locations,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'sharedWithEmails': sharedWithEmails,
    'locations': locations.map((location) => location.toJson()).toList(),
  };
}

class Owner {
  String email;
  List<ListModel> lists;

  Owner({
    required this.email,
    required this.lists,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'lists': lists.map((list) => list.toJson()).toList(),
  };
}
