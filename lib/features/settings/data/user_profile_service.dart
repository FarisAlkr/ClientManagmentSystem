import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;

class UserProfileService {
  static const String _usersCollection = 'users';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload profile picture for a user
  /// Uploads the original image directly (processing can cause encoding issues on web)
  /// Returns the download URL after successful upload and Firestore update verification
  Future<String> uploadProfilePicture(
    String userId,
    Uint8List imageData,
  ) async {
    try {
      print('🖼️ uploadProfilePicture starting for user: $userId');
      print('📦 Original image size: ${imageData.length} bytes');

      // For now, upload the original image directly
      // Image processing with the 'image' package causes encoding issues on Flutter web
      // TODO: Add client-side image resizing using Canvas API for web platform
      final uploadData = imageData;
      print('✅ Using original image data for upload');

      // Detect file type from magic bytes
      String fileExtension = 'jpg';
      String contentType = 'image/jpeg';

      if (uploadData.length >= 3) {
        // Check PNG signature (89 50 4E 47)
        if (uploadData[0] == 0x89 && uploadData[1] == 0x50 && uploadData[2] == 0x4E) {
          fileExtension = 'png';
          contentType = 'image/png';
          print('📄 Detected PNG image');
        }
        // Check JPEG signature (FF D8 FF)
        else if (uploadData[0] == 0xFF && uploadData[1] == 0xD8 && uploadData[2] == 0xFF) {
          fileExtension = 'jpg';
          contentType = 'image/jpeg';
          print('📄 Detected JPEG image');
        }
      }

      // Delete old profile pictures (all files in the folder)
      try {
        final folderRef = _storage.ref('users/$userId/profile_pictures');
        final listResult = await folderRef.listAll();
        for (final item in listResult.items) {
          await item.delete();
          print('🗑️ Deleted old file: ${item.name}');
        }
      } catch (e) {
        print('ℹ️ No old profile pictures to delete (or delete failed): $e');
      }

      // Upload to Firebase Storage with timestamp-based unique filename
      // This ensures each upload gets a completely new URL, avoiding any caching issues
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      print('☁️ Uploading to Firebase Storage with timestamp: $timestamp');
      final ref = _storage.ref('users/$userId/profile_pictures/avatar_$timestamp.$fileExtension');
      final uploadTask = ref.putData(
        uploadData,
        SettableMetadata(
          contentType: contentType,
          cacheControl: 'public, max-age=3600', // Cache for 1 hour
        ),
      );

      // Wait for upload with timeout
      print('⏳ Waiting for upload to complete...');
      await uploadTask.timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          throw TimeoutException('Firebase Storage upload timeout', Duration(minutes: 2));
        },
      );
      print('✅ Upload complete');

      // Get signed download URL (includes CORS headers)
      print('🔗 Getting download URL...');
      final downloadUrl = await ref.getDownloadURL().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Get download URL timeout', Duration(seconds: 30));
        },
      );
      print('✅ Download URL: $downloadUrl');

      // Update user document with profile picture URL
      print('📝 Updating Firestore document...');
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update({
        'profilePictureUrl': downloadUrl,
      }).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Firestore update timeout', Duration(seconds: 30));
        },
      );
      print('✅ Firestore update complete');

      // VERIFICATION: Read back the document to ensure the URL was saved
      print('🔍 Verifying Firestore update...');
      final verificationDoc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get()
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Firestore verification timeout', Duration(seconds: 10));
        },
      );

      final savedUrl = verificationDoc.data()?['profilePictureUrl'] as String?;
      if (savedUrl != downloadUrl) {
        throw Exception(
          'Firestore verification failed: URL mismatch. Expected: $downloadUrl, Got: $savedUrl',
        );
      }
      print('✅ Firestore verification successful - URL saved correctly');

      return downloadUrl;
    } catch (e) {
      print('❌ Error uploading profile picture: $e');
      rethrow;
    }
  }

  /// Delete profile picture for a user
  /// Deletes all profile pictures in the user's profile_pictures folder
  Future<void> deleteProfilePicture(String userId) async {
    try {
      print('🗑️ Deleting profile pictures for user: $userId');

      // List all files in the user's profile_pictures folder
      final folderRef = _storage.ref('users/$userId/profile_pictures');
      final listResult = await folderRef.listAll();

      // Delete all files
      for (final item in listResult.items) {
        try {
          await item.delete();
          print('✅ Deleted: ${item.name}');
        } catch (e) {
          print('⚠️ Failed to delete ${item.name}: $e');
        }
      }

      // Update user document to remove URL
      print('📝 Removing profilePictureUrl from Firestore...');
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update({
        'profilePictureUrl': FieldValue.delete(),
      });
      print('✅ Profile picture deleted successfully');
    } catch (e) {
      print('❌ Error deleting profile picture: $e');
      // Don't rethrow - if file doesn't exist in storage, we still want to update Firestore
      try {
        await _firestore
            .collection(_usersCollection)
            .doc(userId)
            .update({
          'profilePictureUrl': FieldValue.delete(),
        });
        print('✅ Firestore updated despite storage deletion error');
      } catch (firestoreError) {
        print('❌ Failed to update Firestore: $firestoreError');
        rethrow;
      }
    }
  }

  /// Get download URL for profile picture
  /// Returns signed URL that includes CORS headers for web access
  Future<String?> getProfilePictureUrl(String userId) async {
    try {
      final ref = _storage.ref('users/$userId/profile_pictures/avatar.png');
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error getting profile picture URL: $e');
      return null;
    }
  }
}
