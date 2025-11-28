import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/data/services/storage_service.dart';
import '../../../../shared/domain/models/storage_stats.dart';

final storageServiceProvider = Provider((ref) => StorageService());

/// Get storage stats for all users
final allStorageStatsProvider = FutureProvider<List<StorageStats>>((ref) async {
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getAllStorageStats();
});

/// Calculate storage for a specific user
final calculateUserStorageProvider = FutureProvider.family<StorageStats, String>((ref, userId) async {
  final storageService = ref.watch(storageServiceProvider);
  return storageService.calculateUserStorageUsage(userId);
});

/// Get storage stats for a specific user (stream)
final userStorageStatsStreamProvider = StreamProvider.family<StorageStats?, String>((ref, userId) {
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getUserStorageStatsStream(userId);
});
