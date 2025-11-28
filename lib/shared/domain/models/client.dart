class Client {
  final String id;
  final String cityId;
  final String name;
  final String propertyAddress;
  final String idNumber;
  final String handlingCommittee;
  final DateTime createdAt;
  final String userId; // Owner of this client

  const Client({
    required this.id,
    required this.cityId,
    required this.name,
    required this.propertyAddress,
    required this.idNumber,
    required this.handlingCommittee,
    required this.createdAt,
    required this.userId,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String? ?? '',
      cityId: json['city_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      propertyAddress: json['property_address'] as String? ?? '',
      idNumber: json['id_number'] as String? ?? '',
      handlingCommittee: json['handling_committee'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? (json['created_at'] is String
              ? DateTime.parse(json['created_at'] as String)
              : (json['created_at'] as dynamic).toDate())
          : DateTime.now(),
      userId: json['user_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_id': cityId,
      'name': name,
      'property_address': propertyAddress,
      'id_number': idNumber,
      'handling_committee': handlingCommittee,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }

  Client copyWith({
    String? id,
    String? cityId,
    String? name,
    String? propertyAddress,
    String? idNumber,
    String? handlingCommittee,
    DateTime? createdAt,
    String? userId,
  }) {
    return Client(
      id: id ?? this.id,
      cityId: cityId ?? this.cityId,
      name: name ?? this.name,
      propertyAddress: propertyAddress ?? this.propertyAddress,
      idNumber: idNumber ?? this.idNumber,
      handlingCommittee: handlingCommittee ?? this.handlingCommittee,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}