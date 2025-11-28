import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Global search provider for clients across all cities - MUST filter by user_id
final globalSearchProvider = FutureProvider.family.autoDispose<List<GlobalSearchResult>, String>((ref, query) async {
  if (query.trim().isEmpty || query.length < 2) {
    return [];
  }

  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('משתמש לא מחובר');
  }

  final results = <GlobalSearchResult>[];

  try {
    // CRITICAL: Filter by user_id to ensure data isolation
    final citiesQuery = await firestore
        .collection('cities')
        .where('user_id', isEqualTo: user.uid)
        .get()
        .timeout(const Duration(seconds: 5));

    // Filter cities on client side
    final matchingCities = citiesQuery.docs.where((doc) {
      final data = doc.data();
      final name = (data['name'] as String? ?? '').toLowerCase();
      return name.contains(query.toLowerCase());
    }).take(5).toList();

    for (final cityDoc in matchingCities) {
      final cityData = cityDoc.data();
      final cityName = cityData['name'] as String;

      // Count clients in this city - MUST filter by user_id
      final clientsQuery = await firestore
          .collection('clients')
          .where('user_id', isEqualTo: user.uid)
          .where('city_id', isEqualTo: cityDoc.id)
          .get();

      results.add(GlobalSearchResult(
        cityId: cityDoc.id,
        cityName: cityName,
        clientCount: clientsQuery.docs.length,
        type: SearchResultType.city,
      ));
    }

    // CRITICAL: Search in clients collection - filter by user_id
    final clientsQuery = await firestore
        .collection('clients')
        .where('user_id', isEqualTo: user.uid)
        .get()
        .timeout(const Duration(seconds: 5));

    // Filter clients on client side
    final matchingClients = clientsQuery.docs.where((doc) {
      final data = doc.data();
      final name = (data['name'] as String? ?? '').toLowerCase();
      return name.contains(query.toLowerCase());
    }).take(5);

    for (final clientDoc in matchingClients) {
      final clientData = clientDoc.data();

      // Get city name for this client
      final cityId = clientData['city_id'] as String;
      final cityDoc = await firestore.collection('cities').doc(cityId).get();
      final cityName = cityDoc.exists ? cityDoc.data()!['name'] as String : 'Unknown City';

      results.add(GlobalSearchResult(
        cityId: cityId,
        cityName: cityName,
        clientCount: 1,
        clientName: clientData['name'] as String,
        clientId: clientDoc.id,  // Include the client document ID
        type: SearchResultType.client,
      ));
    }

    // Search by committee - use the same client data to avoid extra query
    final matchingCommittees = clientsQuery.docs.where((doc) {
      final data = doc.data();
      final committee = (data['handling_committee'] as String? ?? '').toLowerCase();
      return committee.contains(query.toLowerCase());
    }).take(3);

    // Group by city for committee search
    final committeeResults = <String, GlobalSearchResult>{};
    for (final clientDoc in matchingCommittees) {
      final clientData = clientDoc.data();
      final cityId = clientData['city_id'] as String;

      if (committeeResults.containsKey(cityId)) {
        committeeResults[cityId]!.clientCount++;
      } else {
        // Get city name
        final cityDoc = await firestore.collection('cities').doc(cityId).get();
        final cityName = cityDoc.exists ? cityDoc.data()!['name'] as String : 'Unknown City';

        committeeResults[cityId] = GlobalSearchResult(
          cityId: cityId,
          cityName: cityName,
          clientCount: 1,
          committee: clientData['handling_committee'] as String,
          type: SearchResultType.committee,
        );
      }
    }

    results.addAll(committeeResults.values);

    return results;
  } catch (e) {
    throw Exception('Failed to search: $e');
  }
});

enum SearchResultType { city, client, committee }

class GlobalSearchResult {
  final String cityId;
  final String cityName;
  int clientCount;
  final String? clientName;
  final String? clientId;  // Added clientId for direct navigation
  final String? committee;
  final SearchResultType type;

  GlobalSearchResult({
    required this.cityId,
    required this.cityName,
    required this.clientCount,
    this.clientName,
    this.clientId,
    this.committee,
    required this.type,
  });

  String get displayTitle {
    switch (type) {
      case SearchResultType.city:
        return cityName;
      case SearchResultType.client:
        return clientName ?? cityName;
      case SearchResultType.committee:
        return committee ?? cityName;
    }
  }

  String get displaySubtitle {
    switch (type) {
      case SearchResultType.city:
        return '$clientCount לקוחות';
      case SearchResultType.client:
        return cityName;
      case SearchResultType.committee:
        return '$cityName - $clientCount לקוחות';
    }
  }
}