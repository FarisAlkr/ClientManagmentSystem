class StorageStats {
  final String userId;
  final int totalBytes;
  final int fileCount;
  final DateTime lastCalculated;

  const StorageStats({
    required this.userId,
    required this.totalBytes,
    required this.fileCount,
    required this.lastCalculated,
  });

  // Formatted storage display
  String get formattedStorage {
    if (totalBytes == 0) {
      return '0 B';
    } else if (totalBytes < 1024) {
      return '$totalBytes B';
    } else if (totalBytes < 1024 * 1024) {
      return '${(totalBytes / 1024).toStringAsFixed(2)} KB';
    } else if (totalBytes < 1024 * 1024 * 1024) {
      return '${(totalBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(totalBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  factory StorageStats.fromMap(Map<String, dynamic> map, String userId) {
    return StorageStats(
      userId: userId,
      totalBytes: map['totalBytes'] ?? 0,
      fileCount: map['fileCount'] ?? 0,
      lastCalculated: DateTime.parse(map['lastCalculated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalBytes': totalBytes,
      'fileCount': fileCount,
      'lastCalculated': lastCalculated.toIso8601String(),
    };
  }

  StorageStats copyWith({
    String? userId,
    int? totalBytes,
    int? fileCount,
    DateTime? lastCalculated,
  }) {
    return StorageStats(
      userId: userId ?? this.userId,
      totalBytes: totalBytes ?? this.totalBytes,
      fileCount: fileCount ?? this.fileCount,
      lastCalculated: lastCalculated ?? this.lastCalculated,
    );
  }
}
