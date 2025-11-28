import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/domain/models/city.dart';

class CitiesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'cities';

  Future<List<City>> getCities() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      // Only get cities for the current user
      final snapshot = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .get();

      final cities = snapshot.docs
          .map((doc) => City.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Sort on client side to avoid orderBy security rule issues
      cities.sort((a, b) => a.name.compareTo(b.name));
      return cities;
    } catch (e) {
      throw Exception('Failed to load cities: $e');
    }
  }

  Future<void> addCity(String name, String description) async {
    try {
      // Check if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר - אנא התחבר מחדש');
      }

      // Check for duplicates (case-insensitive) within user's cities only
      final existingQuery = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .where('name_lowercase', isEqualTo: name.toLowerCase())
          .get();

      if (existingQuery.docs.isNotEmpty) {
        throw Exception('העיר קיימת כבר'); // City already exists
      }

      await _firestore.collection(_collection).add({
        'name': name,
        'name_lowercase': name.toLowerCase(), // For case-insensitive search
        'description': description,
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
      if (e.toString().contains('העיר קיימת כבר')) {
        rethrow;
      }
      throw Exception('שגיאה בהוספת העיר: ${e.toString()}');
    }
  }

  Future<void> updateCity(String id, String name, String description) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      // Check for duplicates excluding current city (within user's cities only)
      final existingQuery = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .where('name_lowercase', isEqualTo: name.toLowerCase())
          .get();

      final duplicates = existingQuery.docs.where((doc) => doc.id != id);
      if (duplicates.isNotEmpty) {
        throw Exception('העיר קיימת כבר'); // City already exists
      }

      await _firestore.collection(_collection).doc(id).update({
        'name': name,
        'name_lowercase': name.toLowerCase(),
        'description': description,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCity(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete city: $e');
    }
  }

  Stream<List<City>> getCitiesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    // Only stream cities for the current user
    return _firestore
        .collection(_collection)
        .where('user_id', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          try {
            final cities = snapshot.docs
                .map((doc) {
                  try {
                    return City.fromJson({...doc.data(), 'id': doc.id});
                  } catch (e) {
                    print('Error parsing city document ${doc.id}: $e');
                    return null;
                  }
                })
                .where((city) => city != null)
                .cast<City>()
                .toList();

            // Sort on client side
            cities.sort((a, b) => a.name.compareTo(b.name));
            return cities;
          } catch (e) {
            print('Error processing cities stream: $e');
            return <City>[];
          }
        })
        .handleError((error) {
          print('Firestore stream error: $error');
          return <City>[];
        });
  }
}