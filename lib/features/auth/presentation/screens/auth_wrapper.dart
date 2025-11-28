import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'pending_approval_screen.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../data/services/user_service.dart';
import '../../../../shared/domain/models/app_user.dart';
import '../../../../shared/presentation/widgets/professional_loading_screen.dart';
import '../../../../shared/presentation/widgets/delayed_widget_switcher.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // Use StreamBuilder instead of FutureBuilder to listen to real-time updates
          return StreamBuilder<AppUser?>(
            stream: UserService().getUserDocumentStream(user.uid),
            builder: (context, snapshot) {
              final isLoading = snapshot.connectionState == ConnectionState.waiting;

              Widget contentWidget;
              if (isLoading) {
                contentWidget = const Scaffold(body: SizedBox());
              } else {
                final appUser = snapshot.data;
                if (appUser == null || appUser.status != UserStatus.approved) {
                  // Show pending approval screen for pending users
                  if (appUser?.status == UserStatus.pending) {
                    contentWidget = const PendingApprovalScreen();
                  } else {
                    // Show login screen for rejected or non-existent users
                    contentWidget = const LoginScreen();
                  }
                } else {
                  contentWidget = const DashboardScreen();
                }
              }

              return DelayedWidgetSwitcher(
                isLoading: isLoading,
                loadingWidget: const ProfessionalLoadingScreen(),
                minimumLoadingMilliseconds: 6000, // 6 seconds minimum
                child: contentWidget,
              );
            },
          );
        } else {
          return const LoginScreen();
        }
      },
      loading: () => const ProfessionalLoadingScreen(),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text('Error: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(authStateProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}