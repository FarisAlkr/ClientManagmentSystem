import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Dashboard statistics provider - MUST filter by user_id for data isolation
final dashboardStatsProvider = FutureProvider.autoDispose<DashboardStats>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('משתמש לא מחובר');
  }

  try {
    // CRITICAL: Filter by user_id to ensure data isolation
    final results = await Future.wait([
      firestore
          .collection('cities')
          .where('user_id', isEqualTo: user.uid)
          .limit(1000)
          .get(),
      firestore
          .collection('clients')
          .where('user_id', isEqualTo: user.uid)
          .limit(1000)
          .get(),
    ]).timeout(const Duration(seconds: 10));

    return DashboardStats(
      totalCities: results[0].docs.length,
      totalClients: results[1].docs.length,
    );
  } catch (e) {
    print('Error loading dashboard stats: $e');
    rethrow;
  }
});

class DashboardStats {
  final int totalCities;
  final int totalClients;

  const DashboardStats({
    required this.totalCities,
    required this.totalClients,
  });
}