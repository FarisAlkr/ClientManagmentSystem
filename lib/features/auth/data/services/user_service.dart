import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/domain/models/app_user.dart';

class UserService {
  static const String _usersCollection = 'users';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user document after registration
  Future<void> createUserDocument(User firebaseUser, {String? displayName}) async {
    final appUser = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: displayName ?? firebaseUser.displayName,
      status: UserStatus.pending, // Default to pending
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection(_usersCollection)
        .doc(firebaseUser.uid)
        .set(appUser.toMap());
  }

  // Create user document for existing users (with approved status)
  Future<void> createExistingUserDocument(User firebaseUser, {String? displayName}) async {
    final appUser = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: displayName ?? firebaseUser.displayName,
      status: UserStatus.approved, // Approve existing users automatically
      createdAt: DateTime.now(),
      approvedAt: DateTime.now(),
      approvedBy: 'system (existing user)',
    );

    await _firestore
        .collection(_usersCollection)
        .doc(firebaseUser.uid)
        .set(appUser.toMap());
  }

  // Get user document
  Future<AppUser?> getUserDocument(String uid) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return AppUser.fromMap(doc.data()!, uid);
      }
    } catch (e) {
      print('Error getting user document: $e');
    }
    return null;
  }

  // Get user document as stream for real-time updates
  Stream<AppUser?> getUserDocumentStream(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return AppUser.fromMap(doc.data()!, uid);
      }
      return null;
    });
  }

  // Check if current user is approved
  Future<bool> isCurrentUserApproved() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    final appUser = await getUserDocument(currentUser.uid);
    return appUser?.status == UserStatus.approved;
  }

  // Get current user status
  Future<UserStatus?> getCurrentUserStatus() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    final appUser = await getUserDocument(currentUser.uid);
    return appUser?.status;
  }

  // Admin functions
  Future<List<AppUser>> getPendingUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('status', isEqualTo: UserStatus.pending.name)
          .get();

      final users = querySnapshot.docs
          .map((doc) => AppUser.fromMap(doc.data(), doc.id))
          .toList();

      // Sort in memory instead of Firestore to avoid index requirements
      users.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return users;
    } catch (e) {
      print('Error fetching pending users: $e');
      rethrow;
    }
  }

  // Approve user
  Future<void> approveUser(String uid, String approvedBy) async {
    await _firestore
        .collection(_usersCollection)
        .doc(uid)
        .update({
      'status': UserStatus.approved.name,
      'approvedAt': DateTime.now().toIso8601String(),
      'approvedBy': approvedBy,
    });
  }

  // Reject user
  Future<void> rejectUser(String uid, String rejectedBy) async {
    await _firestore
        .collection(_usersCollection)
        .doc(uid)
        .update({
      'status': UserStatus.rejected.name,
      'rejectedAt': DateTime.now().toIso8601String(),
      'rejectedBy': rejectedBy,
    });
  }

  // Get all users (for admin)
  Future<List<AppUser>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .get();

      final users = querySnapshot.docs
          .map((doc) => AppUser.fromMap(doc.data(), doc.id))
          .toList();

      // Sort in memory
      users.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return users;
    } catch (e) {
      print('Error fetching all users: $e');
      rethrow;
    }
  }
}