enum UserStatus {
  pending,
  approved,
  rejected;

  String get displayName {
    switch (this) {
      case UserStatus.pending:
        return 'ממתין לאישור';
      case UserStatus.approved:
        return 'מאושר';
      case UserStatus.rejected:
        return 'נדחה';
    }
  }

  String get displayNameEnglish {
    switch (this) {
      case UserStatus.pending:
        return 'Pending';
      case UserStatus.approved:
        return 'Approved';
      case UserStatus.rejected:
        return 'Rejected';
    }
  }
}

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final UserStatus status;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final String? approvedBy;
  final DateTime? rejectedAt;
  final String? rejectedBy;
  final String? profilePictureUrl;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    required this.status,
    required this.createdAt,
    this.approvedAt,
    this.approvedBy,
    this.rejectedAt,
    this.rejectedBy,
    this.profilePictureUrl,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      status: UserStatus.values.firstWhere(
        (status) => status.name == map['status'],
        orElse: () => UserStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      approvedAt: map['approvedAt'] != null ? DateTime.parse(map['approvedAt']) : null,
      approvedBy: map['approvedBy'],
      rejectedAt: map['rejectedAt'] != null ? DateTime.parse(map['rejectedAt']) : null,
      rejectedBy: map['rejectedBy'],
      profilePictureUrl: map['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'approvedBy': approvedBy,
      'rejectedAt': rejectedAt?.toIso8601String(),
      'rejectedBy': rejectedBy,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  AppUser copyWith({
    String? email,
    String? displayName,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? approvedAt,
    String? approvedBy,
    DateTime? rejectedAt,
    String? rejectedBy,
    String? profilePictureUrl,
  }) {
    return AppUser(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      rejectedBy: rejectedBy ?? this.rejectedBy,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    );
  }
}