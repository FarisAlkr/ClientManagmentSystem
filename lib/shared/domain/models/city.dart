class City {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final String userId; // Owner of this city

  const City({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.userId,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? (json['created_at'] as dynamic).toDate()
          : DateTime.now(),
      userId: json['user_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }

  City copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    String? userId,
  }) {
    return City(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}