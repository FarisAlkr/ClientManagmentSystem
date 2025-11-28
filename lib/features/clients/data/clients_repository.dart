import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/domain/models/client.dart';

class ClientsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'clients';

  Future<List<Client>> getClientsByCity(String cityId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      // Only get clients for the current user
      final snapshot = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .where('city_id', isEqualTo: cityId)
          .get();

      final clients = snapshot.docs
          .map((doc) => Client.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Sort by created_at in memory (descending - newest first)
      clients.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return clients;
    } catch (e) {
      throw Exception('Failed to load clients: $e');
    }
  }

  Future<void> addClient({
    required String cityId,
    required String name,
    required String propertyAddress,
    required String idNumber,
    required String handlingCommittee,
  }) async {
    try {
      // Check if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר - אנא התחבר מחדש');
      }

      // Check for duplicate ID number (within user's clients only)
      final existingQuery = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .where('id_number', isEqualTo: idNumber)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        throw Exception('לקוח עם תעודת זהות זו כבר קיים במערכת');
      }

      await _firestore.collection(_collection).add({
        'city_id': cityId,
        'name': name,
        'property_address': propertyAddress,
        'id_number': idNumber,
        'handling_committee': handlingCommittee,
        'name_lowercase': name.toLowerCase(), // For search
        'created_at': FieldValue.serverTimestamp(),
        'user_id': user.uid, // Add user_id field
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('אין הרשאה לבצע פעולה זו - אנא התחבר מחדש');
      } else if (e.code == 'unavailable') {
        throw Exception('שירות Firebase אינו זמין - בדוק את החיבור לאינטרנט');
      } else {
        throw Exception('שגיאת Firebase: ${e.message}');
      }
    } catch (e) {
      if (e.toString().contains('לקוח עם תעודת זהות זו כבר קיים במערכת')) {
        rethrow;
      }
      throw Exception('שגיאה בהוספת הלקוח: ${e.toString()}');
    }
  }

  Future<void> updateClient(
    String id, {
    required String name,
    required String propertyAddress,
    required String idNumber,
    required String handlingCommittee,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      // Check for duplicate ID number excluding current client (within user's clients only)
      final existingQuery = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .where('id_number', isEqualTo: idNumber)
          .get();

      final duplicates = existingQuery.docs.where((doc) => doc.id != id);
      if (duplicates.isNotEmpty) {
        throw Exception('לקוח עם תעודת זהות זו כבר קיים במערכת');
      }

      await _firestore.collection(_collection).doc(id).update({
        'name': name,
        'property_address': propertyAddress,
        'id_number': idNumber,
        'handling_committee': handlingCommittee,
        'name_lowercase': name.toLowerCase(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteClient(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete client: $e');
    }
  }

  Stream<List<Client>> getClientsByCityStream(String cityId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    // Only stream clients for the current user
    // NOTE: Removed orderBy to avoid composite index requirement
    // Sorting will be done in-memory instead
    return _firestore
        .collection(_collection)
        .where('user_id', isEqualTo: user.uid)
        .where('city_id', isEqualTo: cityId)
        .snapshots()
        .map((snapshot) {
          try {
            final clients = snapshot.docs
                .map((doc) {
                  try {
                    return Client.fromJson({...doc.data(), 'id': doc.id});
                  } catch (e) {
                    print('Error parsing client document ${doc.id}: $e');
                    return null;
                  }
                })
                .where((client) => client != null)
                .cast<Client>()
                .toList();

            // Sort by created_at in memory (descending - newest first)
            clients.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return clients;
          } catch (e) {
            print('Error processing clients stream: $e');
            return <Client>[];
          }
        })
        .handleError((error) {
          print('Firestore stream error: $error');
          // Return empty list on stream error
          return <Client>[];
        });
  }

  Future<Client?> getClient(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Client.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load client: $e');
    }
  }
}