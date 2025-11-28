import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/presentation/screens/auth_wrapper.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/cities/presentation/screens/cities_screen.dart';
import '../../features/clients/presentation/screens/clients_screen.dart';
import '../../features/clients/presentation/screens/client_detail_screen.dart';
import '../../features/projects/presentation/screens/project_checklist_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard.dart';
import '../../features/admin/presentation/screens/admin_login_screen.dart';
import '../../features/committees/presentation/screens/committees_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/cities',
        builder: (context, state) {
          final view = state.uri.queryParameters['view'];
          return CitiesScreen(view: view);
        },
      ),
      GoRoute(
        path: '/clients/:cityId',
        builder: (context, state) {
          final cityId = state.pathParameters['cityId'];
          if (cityId == null || cityId.isEmpty) {
            // Redirect to cities if no valid cityId
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('עיר לא נמצאה'),
                    SizedBox(height: 16),
                    Text('אנא בחר עיר מהרשימה'),
                  ],
                ),
              ),
            );
          }
          final cityName = state.uri.queryParameters['cityName'] ?? '';
          return ClientsScreen(cityId: cityId, cityName: cityName);
        },
      ),
      GoRoute(
        path: '/client/:clientId',
        builder: (context, state) {
          final clientId = state.pathParameters['clientId'];
          if (clientId == null || clientId.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('לקוח לא נמצא'),
                    SizedBox(height: 16),
                    Text('אנא בחר לקוח מהרשימה'),
                  ],
                ),
              ),
            );
          }
          final cityName = state.uri.queryParameters['cityName'];
          return ClientDetailScreen(clientId: clientId, cityName: cityName);
        },
      ),
      GoRoute(
        path: '/project/:clientId',
        builder: (context, state) {
          final clientId = state.pathParameters['clientId'];
          if (clientId == null || clientId.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('פרויקט לא נמצא'),
                    SizedBox(height: 16),
                    Text('אנא בחר לקוח תחילה'),
                  ],
                ),
              ),
            );
          }
          return ProjectChecklistScreen(clientId: clientId);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/committees',
        builder: (context, state) => const CommitteesScreen(),
      ),
      GoRoute(
        path: '/admin-login',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin-panel',
        redirect: (context, state) async {
          // Check if user is logged in
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return '/admin-login';
          }

          // Verify admin claims
          try {
            final idTokenResult = await user.getIdTokenResult();
            final isAdmin = idTokenResult.claims?['admin'] == true;
            if (!isAdmin) {
              return '/auth';
            }
          } catch (e) {
            return '/admin-login';
          }

          return null; // Allow access if logged in and admin
        },
        builder: (context, state) => const AdminDashboard(),
      ),
    ],
  );
});