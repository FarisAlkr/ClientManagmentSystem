import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/domain/models/committee.dart';

class CommitteesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'committees';

  Future<List<Committee>> getCommittees() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      final snapshot = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .get();

      final committees = snapshot.docs
          .map((doc) => Committee.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      committees.sort((a, b) => a.name.compareTo(b.name));
      return committees;
    } catch (e) {
      throw Exception('Failed to load committees: $e');
    }
  }

  Stream<List<Committee>> getCommitteesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collection)
        .where('user_id', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          try {
            final committees = snapshot.docs
                .map((doc) {
                  try {
                    return Committee.fromJson({...doc.data(), 'id': doc.id});
                  } catch (e) {
                    print('Error parsing committee document ${doc.id}: $e');
                    return null;
                  }
                })
                .where((committee) => committee != null)
                .cast<Committee>()
                .toList();

            committees.sort((a, b) => a.name.compareTo(b.name));
            return committees;
          } catch (e) {
            print('Error processing committees stream: $e');
            return <Committee>[];
          }
        })
        .handleError((error) {
          print('Firestore stream error: $error');
          return <Committee>[];
        });
  }

  Future<void> addCommittee(String name) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      // Check for duplicates (case-insensitive)
      final existingQuery = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .where('name_lowercase', isEqualTo: name.toLowerCase())
          .get();

      if (existingQuery.docs.isNotEmpty) {
        throw Exception('הוועדה כבר קיימת');
      }

      await _firestore.collection(_collection).add({
        'name': name,
        'name_lowercase': name.toLowerCase(),
        'created_at': FieldValue.serverTimestamp(),
        'user_id': user.uid,
      });
    } catch (e) {
      if (e.toString().contains('הוועדה כבר קיימת')) {
        rethrow;
      }
      throw Exception('שגיאה בהוספת הוועדה: ${e.toString()}');
    }
  }

  Future<void> updateCommittee(String id, String name) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      // Check for duplicates excluding current committee
      final existingQuery = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .where('name_lowercase', isEqualTo: name.toLowerCase())
          .get();

      final duplicates = existingQuery.docs.where((doc) => doc.id != id);
      if (duplicates.isNotEmpty) {
        throw Exception('הוועדה כבר קיימת');
      }

      await _firestore.collection(_collection).doc(id).update({
        'name': name,
        'name_lowercase': name.toLowerCase(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCommittee(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete committee: $e');
    }
  }
}
