class Committee {
  final String id;
  final String name;
  final DateTime createdAt;

  const Committee({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Committee.fromJson(Map<String, dynamic> json) {
    return Committee(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'])
          : (json['created_at'] as DateTime),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
