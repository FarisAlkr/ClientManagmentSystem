import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/committees_repository.dart';
import '../providers/committees_provider.dart';
import '../widgets/add_committee_dialog.dart';
import '../widgets/edit_committee_dialog.dart';

class CommitteesScreen extends ConsumerStatefulWidget {
  const CommitteesScreen({super.key});

  @override
  ConsumerState<CommitteesScreen> createState() => _CommitteesScreenState();
}

class _CommitteesScreenState extends ConsumerState<CommitteesScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final committeesAsync = ref.watch(committeesStreamProvider);
    final searchQuery = ref.watch(searchCommitteeQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.committees,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.success,
                    AppTheme.success.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.success.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => _addCommittee(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Modern Search Bar
          Container(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: TextField(
                autofocus: false,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  ref.read(searchCommitteeQueryProvider.notifier).state = value;
                },
                decoration: InputDecoration(
                  hintText: l10n.searchCommittees,
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.search,
                      color: AppTheme.success,
                      size: 24,
                    ),
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          child: IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.clear,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                            onPressed: () {
                              ref.read(searchCommitteeQueryProvider.notifier).state = '';
                            },
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
          ),

          // Committees List
          Expanded(
            child: committeesAsync.when(
              data: (committees) {
                final filtered = searchQuery.isEmpty
                    ? committees
                    : committees
                        .where((c) =>
                            c.name.toLowerCase().contains(searchQuery.toLowerCase()))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          searchQuery.isEmpty ? Icons.location_city : Icons.search_off,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          searchQuery.isEmpty
                              ? l10n.noCommitteesInSystem
                              : l10n.noCommitteesFoundSearch,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        if (searchQuery.isEmpty)
                          Text(
                            l10n.addFirstCommittee,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                        const SizedBox(height: 32),
                        if (searchQuery.isEmpty)
                          ElevatedButton.icon(
                            onPressed: () => _addCommittee(),
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addCommittee),
                          ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final committee = filtered[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.primaryBlue,
                    child: Icon(Icons.gavel, color: Colors.white),
                  ),
                  title: Text(
                    committee.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppTheme.primaryBlue),
                        onPressed: () => _editCommittee(committee),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCommittee(committee),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      l10n.errorLoadingCommitteesList,
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addCommittee() {
    showDialog(
      context: context,
      builder: (context) => const AddCommitteeDialog(),
    );
  }

  void _editCommittee(committee) {
    showDialog(
      context: context,
      builder: (context) => EditCommitteeDialog(committee: committee),
    );
  }

  void _deleteCommittee(committee) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteCommitteeTitle),
        content: Text(l10n.confirmDeleteCommittee(committee.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                final repository = ref.read(committeesRepositoryProvider);
                await repository.deleteCommittee(committee.id);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.committeeDeletedSuccessfully),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.error}: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
