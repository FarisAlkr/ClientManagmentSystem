import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../shared/domain/models/storage_stats.dart';

class StorageService {
  static const String _storageStatsCollection = 'storage_stats';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Calculate storage usage for a specific user
  /// This traverses all files in the user's storage directory
  Future<StorageStats> calculateUserStorageUsage(String userId) async {
    try {
      int totalBytes = 0;
      int fileCount = 0;

      // Get all files from user's storage directory
      final userStorageRef = _storage.ref('users/$userId');

      // List all files recursively
      final listResult = await userStorageRef.listAll();

      // Process all files and subdirectories
      final queue = <ListResult>[listResult];

      while (queue.isNotEmpty) {
        final current = queue.removeAt(0);

        // Count files in current directory
        for (final file in current.items) {
          try {
            final metadata = await file.getMetadata();
            totalBytes += metadata.size ?? 0;
            fileCount++;
          } catch (e) {
            print('Error getting file metadata for ${file.fullPath}: $e');
          }
        }

        // Add subdirectories to queue for processing
        // Convert Reference list to ListResult by calling listAll() on each prefix
        for (final prefix in current.prefixes) {
          try {
            final subListResult = await prefix.listAll();
            queue.add(subListResult);
          } catch (e) {
            print('Error listing subdirectory ${prefix.fullPath}: $e');
          }
        }
      }

      final stats = StorageStats(
        userId: userId,
        totalBytes: totalBytes,
        fileCount: fileCount,
        lastCalculated: DateTime.now(),
      );

      // Save stats to Firestore for caching
      await _firestore
          .collection(_storageStatsCollection)
          .doc(userId)
          .set(stats.toMap());

      return stats;
    } catch (e) {
      print('Error calculating storage usage for user $userId: $e');
      rethrow;
    }
  }

  /// Get cached storage stats for a user
  /// Returns null if stats haven't been calculated yet
  Future<StorageStats?> getUserStorageStats(String userId) async {
    try {
      final doc = await _firestore
          .collection(_storageStatsCollection)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return StorageStats.fromMap(doc.data()!, userId);
      }
    } catch (e) {
      print('Error fetching storage stats for user $userId: $e');
    }
    return null;
  }

  /// Get storage stats as a stream for real-time updates
  Stream<StorageStats?> getUserStorageStatsStream(String userId) {
    return _firestore
        .collection(_storageStatsCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return StorageStats.fromMap(doc.data()!, userId);
      }
      return null;
    });
  }

  /// Get all storage stats (for admin dashboard)
  Future<List<StorageStats>> getAllStorageStats() async {
    try {
      final querySnapshot = await _firestore
          .collection(_storageStatsCollection)
          .get();

      return querySnapshot.docs
          .map((doc) => StorageStats.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching all storage stats: $e');
      rethrow;
    }
  }

  /// Recalculate storage for all users (admin function)
  /// Returns count of users processed
  Future<int> recalculateAllStorageUsage(List<String> userIds) async {
    int processedCount = 0;

    for (final userId in userIds) {
      try {
        await calculateUserStorageUsage(userId);
        processedCount++;
      } catch (e) {
        print('Error recalculating storage for user $userId: $e');
      }
    }

    return processedCount;
  }
}
