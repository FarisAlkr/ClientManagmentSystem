import 'dart:convert';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/domain/models/city.dart';
import '../../../shared/domain/models/client.dart';
import '../../../shared/domain/models/project.dart';

class BackupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Export all user data to JSON file
  Future<void> exportAllData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      print('🔄 Starting data export for user: ${user.uid}');

      // Fetch all data
      final cities = await _exportCities(user.uid);
      final clients = await _exportClients(user.uid);
      final projects = await _exportProjects(user.uid);
      final committees = await _exportCommittees(user.uid);

      // Create backup structure
      final backup = {
        'version': '2.0', // Incremented version for new format
        'exported_at': DateTime.now().toIso8601String(),
        'user_id': user.uid,
        'user_email': user.email,
        'data': {
          'cities': cities,
          'clients': clients,
          'projects': projects,
          'committees': committees,
        },
        'stats': {
          'total_cities': cities.length,
          'total_clients': clients.length,
          'total_projects': projects.length,
          'total_committees': committees.length,
        }
      };

      // Convert to JSON
      final jsonString = const JsonEncoder.withIndent('  ').convert(backup);

      // Download as file
      final bytes = utf8.encode(jsonString);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'backup_${DateTime.now().millisecondsSinceEpoch}.json';

      html.document.body?.children.add(anchor);
      anchor.click();

      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);

      print('✅ Export completed successfully');
    } catch (e) {
      print('❌ Export failed: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _exportCities(String userId) async {
    final snapshot = await _firestore
        .collection('cities')
        .where('user_id', isEqualTo: userId)
        .get();

    // Include document IDs for proper restoration
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['_id'] = doc.id; // Store original ID
      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _exportClients(String userId) async {
    final snapshot = await _firestore
        .collection('clients')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['_id'] = doc.id;
      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _exportProjects(String userId) async {
    final snapshot = await _firestore
        .collection('projects')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['_id'] = doc.id;
      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _exportCommittees(String userId) async {
    final snapshot = await _firestore
        .collection('committees')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['_id'] = doc.id;
      return data;
    }).toList();
  }

  /// Import data from JSON backup
  Future<ImportResult> importData(String jsonContent) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      print('🔄 Starting data import for user: ${user.uid}');

      // Parse JSON
      final backup = json.decode(jsonContent) as Map<String, dynamic>;

      // Validate backup structure
      if (!backup.containsKey('data') || !backup.containsKey('version')) {
        throw Exception('קובץ הגיבוי פגום או לא תקין');
      }

      final data = backup['data'] as Map<String, dynamic>;
      int citiesImported = 0;
      int clientsImported = 0;
      int projectsImported = 0;
      int committeesImported = 0;

      // Use batch writes for better performance (max 500 operations per batch)
      WriteBatch batch = _firestore.batch();
      int batchCount = 0;

      // Import cities with ID preservation
      if (data.containsKey('cities')) {
        final cities = data['cities'] as List;
        for (var cityData in cities) {
          final cityMap = Map<String, dynamic>.from(cityData as Map<String, dynamic>);
          final docId = cityMap.remove('_id') as String?;
          cityMap['user_id'] = user.uid;

          final docRef = docId != null
              ? _firestore.collection('cities').doc(docId)
              : _firestore.collection('cities').doc();

          batch.set(docRef, cityMap);
          citiesImported++;
          batchCount++;

          if (batchCount >= 500) {
            await batch.commit();
            batch = _firestore.batch();
            batchCount = 0;
          }
        }
      }

      // Import committees with ID preservation
      if (data.containsKey('committees')) {
        final committees = data['committees'] as List;
        for (var committeeData in committees) {
          final committeeMap = Map<String, dynamic>.from(committeeData as Map<String, dynamic>);
          final docId = committeeMap.remove('_id') as String?;
          committeeMap['user_id'] = user.uid;

          final docRef = docId != null
              ? _firestore.collection('committees').doc(docId)
              : _firestore.collection('committees').doc();

          batch.set(docRef, committeeMap);
          committeesImported++;
          batchCount++;

          if (batchCount >= 500) {
            await batch.commit();
            batch = _firestore.batch();
            batchCount = 0;
          }
        }
      }

      // Import clients with ID preservation
      if (data.containsKey('clients')) {
        final clients = data['clients'] as List;
        for (var clientData in clients) {
          final clientMap = Map<String, dynamic>.from(clientData as Map<String, dynamic>);
          final docId = clientMap.remove('_id') as String?;
          clientMap['user_id'] = user.uid;

          final docRef = docId != null
              ? _firestore.collection('clients').doc(docId)
              : _firestore.collection('clients').doc();

          batch.set(docRef, clientMap);
          clientsImported++;
          batchCount++;

          if (batchCount >= 500) {
            await batch.commit();
            batch = _firestore.batch();
            batchCount = 0;
          }
        }
      }

      // Import projects with ID preservation
      if (data.containsKey('projects')) {
        final projects = data['projects'] as List;
        for (var projectData in projects) {
          final projectMap = Map<String, dynamic>.from(projectData as Map<String, dynamic>);
          final docId = projectMap.remove('_id') as String?;
          projectMap['user_id'] = user.uid;

          final docRef = docId != null
              ? _firestore.collection('projects').doc(docId)
              : _firestore.collection('projects').doc();

          batch.set(docRef, projectMap);
          projectsImported++;
          batchCount++;

          if (batchCount >= 500) {
            await batch.commit();
            batch = _firestore.batch();
            batchCount = 0;
          }
        }
      }

      // Commit remaining operations
      if (batchCount > 0) {
        await batch.commit();
      }

      print('✅ Import completed: $citiesImported cities, $clientsImported clients, $projectsImported projects, $committeesImported committees');

      return ImportResult(
        success: true,
        citiesImported: citiesImported,
        clientsImported: clientsImported,
        projectsImported: projectsImported,
        committeesImported: committeesImported,
      );
    } catch (e) {
      print('❌ Import failed: $e');
      return ImportResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Delete all user data (for testing or account deletion)
  Future<void> deleteAllUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('משתמש לא מחובר');
    }

    print('🔄 Starting deletion of all user data');

    // Use batch deletes for better performance
    WriteBatch batch = _firestore.batch();
    int batchCount = 0;

    // Delete cities
    final citiesSnapshot = await _firestore
        .collection('cities')
        .where('user_id', isEqualTo: user.uid)
        .get();
    for (var doc in citiesSnapshot.docs) {
      batch.delete(doc.reference);
      batchCount++;
      if (batchCount >= 500) {
        await batch.commit();
        batch = _firestore.batch();
        batchCount = 0;
      }
    }

    // Delete committees
    final committeesSnapshot = await _firestore
        .collection('committees')
        .where('user_id', isEqualTo: user.uid)
        .get();
    for (var doc in committeesSnapshot.docs) {
      batch.delete(doc.reference);
      batchCount++;
      if (batchCount >= 500) {
        await batch.commit();
        batch = _firestore.batch();
        batchCount = 0;
      }
    }

    // Delete clients
    final clientsSnapshot = await _firestore
        .collection('clients')
        .where('user_id', isEqualTo: user.uid)
        .get();
    for (var doc in clientsSnapshot.docs) {
      batch.delete(doc.reference);
      batchCount++;
      if (batchCount >= 500) {
        await batch.commit();
        batch = _firestore.batch();
        batchCount = 0;
      }
    }

    // Delete projects
    final projectsSnapshot = await _firestore
        .collection('projects')
        .where('user_id', isEqualTo: user.uid)
        .get();
    for (var doc in projectsSnapshot.docs) {
      batch.delete(doc.reference);
      batchCount++;
      if (batchCount >= 500) {
        await batch.commit();
        batch = _firestore.batch();
        batchCount = 0;
      }
    }

    // Commit remaining operations
    if (batchCount > 0) {
      await batch.commit();
    }

    print('✅ All user data deleted');
  }
}

class ImportResult {
  final bool success;
  final int citiesImported;
  final int clientsImported;
  final int projectsImported;
  final int committeesImported;
  final String? error;

  ImportResult({
    required this.success,
    this.citiesImported = 0,
    this.clientsImported = 0,
    this.projectsImported = 0,
    this.committeesImported = 0,
    this.error,
  });
}
