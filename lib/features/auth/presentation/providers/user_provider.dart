import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/domain/models/app_user.dart';
import '../../../auth/data/services/user_service.dart';

final userServiceProvider = Provider((ref) => UserService());

/// Get current logged-in user's AppUser document (with profile picture, status, etc.)
/// Uses StreamProvider for real-time updates when profile picture or other data changes
/// Note: Different from currentUserProvider in settings_provider.dart which returns Firebase User
final appUserProvider = StreamProvider<AppUser?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value(null);
  }

  final userService = ref.watch(userServiceProvider);
  return userService.getUserDocumentStream(user.uid);
});
