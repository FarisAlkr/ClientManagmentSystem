import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/models/app_user.dart';
import '../../../../shared/domain/models/storage_stats.dart';
import '../../../auth/data/services/user_service.dart';
import '../../../../shared/presentation/widgets/profile_picture_widget.dart';
import '../providers/storage_provider.dart';

final pendingUsersProvider = FutureProvider.autoDispose<List<AppUser>>((ref) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    throw Exception('לא מחובר למערכת');
  }

  final userService = UserService();
  return await userService.getPendingUsers();
});

final allUsersProvider = FutureProvider.autoDispose<List<AppUser>>((ref) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    throw Exception('לא מחובר למערכת');
  }

  final userService = UserService();
  return await userService.getAllUsers();
});

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _approveUser(AppUser user) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final userService = UserService();
      final currentUser = FirebaseAuth.instance.currentUser;
      await userService.approveUser(user.uid, currentUser?.email ?? 'admin');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.userApprovedSuccessfully(user.email)),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refresh the data
      ref.invalidate(pendingUsersProvider);
      ref.invalidate(allUsersProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorApprovingUser}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectUser(AppUser user) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final userService = UserService();
      final currentUser = FirebaseAuth.instance.currentUser;
      await userService.rejectUser(user.uid, currentUser?.email ?? 'admin');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.userRejected(user.email)),
            backgroundColor: Colors.orange,
          ),
        );
      }

      // Refresh the data
      ref.invalidate(pendingUsersProvider);
      ref.invalidate(allUsersProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorRejectingUser}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        context.go('/admin-login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorLoggingOut}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.userManagement),
            if (currentUser?.email != null)
              Text(
                currentUser!.email!,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(pendingUsersProvider);
              ref.invalidate(allUsersProvider);
              ref.invalidate(allStorageStatsProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.refreshingData),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refreshData,
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: l10n.disconnect,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.pending_actions),
              text: l10n.pendingApproval,
            ),
            Tab(
              icon: const Icon(Icons.people),
              text: l10n.allUsers,
            ),
            const Tab(
              icon: Icon(Icons.storage),
              text: 'Storage',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingUsersTab(),
          _buildAllUsersTab(),
          _buildStorageStatsTab(),
        ],
      ),
    );
  }

  Widget _buildPendingUsersTab() {
    final l10n = AppLocalizations.of(context)!;
    final pendingUsersAsync = ref.watch(pendingUsersProvider);

    return pendingUsersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noPendingUsers,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildUserCard(user, isPending: true);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('${l10n.errorLoadingData}: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(pendingUsersProvider),
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllUsersTab() {
    final l10n = AppLocalizations.of(context)!;
    final allUsersAsync = ref.watch(allUsersProvider);

    return allUsersAsync.when(
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noUsersInSystem,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildUserCard(user, isPending: false);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('${l10n.errorLoadingData}: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(allUsersProvider),
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(AppUser user, {required bool isPending}) {
    final l10n = AppLocalizations.of(context)!;
    Color statusColor;
    IconData statusIcon;

    switch (user.status) {
      case UserStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case UserStatus.approved:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case UserStatus.rejected:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfilePictureWidget(
                  imageUrl: user.profilePictureUrl,
                  email: user.email,
                  size: 50,
                  enableUpload: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              user.email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          user.status.displayName,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.registrationDate}: ${_formatDate(user.createdAt)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            if (user.approvedAt != null) ...[
              const SizedBox(height: 4),
              Text(
                '${l10n.approvalDate}: ${_formatDate(user.approvedAt!)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
            if (user.approvedBy != null) ...[
              const SizedBox(height: 4),
              Text(
                '${l10n.approvedBy}: ${user.approvedBy}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
            if (user.rejectedAt != null) ...[
              const SizedBox(height: 4),
              Text(
                '${l10n.rejectionDate}: ${_formatDate(user.rejectedAt!)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
            if (user.rejectedBy != null) ...[
              const SizedBox(height: 4),
              Text(
                '${l10n.rejectedBy}: ${user.rejectedBy}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
            if (isPending && user.status == UserStatus.pending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _approveUser(user),
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: Text(l10n.approve),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _rejectUser(user),
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: Text(l10n.reject),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStorageStatsTab() {
    final storageStatsAsync = ref.watch(allStorageStatsProvider);

    return storageStatsAsync.when(
      data: (stats) {
        if (stats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.storage,
                  size: 64,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No storage data calculated yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Click the button below to calculate storage usage for all users. This will scan their files and show you how much storage each user is using.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _calculateAllStorageUsage,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculate Storage Usage for All Users'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        // Sort by total bytes descending
        final sortedStats = List<StorageStats>.from(stats)
          ..sort((a, b) => b.totalBytes.compareTo(a.totalBytes));

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _calculateAllStorageUsage,
                icon: const Icon(Icons.refresh),
                label: const Text('Recalculate All Storage'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sortedStats.length,
                itemBuilder: (context, index) {
                  final stat = sortedStats[index];
                  return _buildStorageCard(stat);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading storage data: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(allStorageStatsProvider),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageCard(StorageStats stats) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storage, color: Colors.blue, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<AppUser?>(
                        future: UserService().getUserDocument(stats.userId),
                        builder: (context, snapshot) {
                          final email = snapshot.data?.email ?? stats.userId;
                          return Text(
                            email,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${stats.fileCount} files',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    stats.formattedStorage,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Updated: ${_formatDate(stats.lastCalculated)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _getStorageProgressValue(),
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getStorageColor(stats.totalBytes),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStorageColor(int bytes) {
    // 1GB = 1073741824 bytes
    const gb = 1073741824;
    final gb5 = 5 * gb;
    final gb10 = 10 * gb;

    if (bytes < gb5) return Colors.green;
    if (bytes < gb10) return Colors.orange;
    return Colors.red;
  }

  double _getStorageProgressValue() {
    // Assuming max storage is 20GB for visualization
    return 0.5; // This would need to be calculated based on max quota
  }

  Future<void> _calculateAllStorageUsage() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final userService = UserService();
      final users = await userService.getAllUsers();

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text('Calculating storage for ${users.length} users...'),
            ],
          ),
        ),
      );

      // Calculate storage for all users
      int completed = 0;
      for (final user in users) {
        try {
          await ref.read(calculateUserStorageProvider(user.uid).future);
          completed++;
        } catch (e) {
          print('Error calculating storage for ${user.email}: $e');
        }
      }

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calculated storage for $completed/${users.length} users'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Invalidate to refresh the stats display
      ref.invalidate(allStorageStatsProvider);
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog if open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorLoadingData}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}