class ListModel {
  final int? id;
  final String name;

  ListModel({this.id, required this.name});

  // Convert a ListModel to a Map (for database insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Create a ListModel from a Map (from database query results)
  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['id'],
      name: map['name'],
    );
  }
}