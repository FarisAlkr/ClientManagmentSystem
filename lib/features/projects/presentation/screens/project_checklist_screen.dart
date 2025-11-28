import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/models/client.dart';
import '../../../clients/presentation/providers/clients_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/stage_card.dart';
import '../widgets/project_summary_card.dart';
import '../widgets/export_pdf_button.dart';
import '../widgets/manage_stages_dialog.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

class ProjectChecklistScreen extends ConsumerWidget {
  final String clientId;

  const ProjectChecklistScreen({
    super.key,
    required this.clientId,
  });

  void _showAddStageDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addStage),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.stageTitle,
            hintText: l10n.enterStageName,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(projectNotifierProvider(clientId).notifier)
                    .addStage(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _showDeleteStageDialog(BuildContext context, WidgetRef ref, String stageId, String stageTitle) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteStage),
        content: Text(l10n.confirmDeleteStage(stageTitle)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(projectNotifierProvider(clientId).notifier)
                  .deleteStage(stageId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showManageStagesDialog(BuildContext context, dynamic project) {
    showDialog(
      context: context,
      builder: (context) => ManageStagesDialog(
        projectId: project.id,
        stages: project.stages,
        onStagesUpdated: () {
          // Refresh the project when stages are updated
          // This will be handled by the Riverpod provider invalidation in the dialog
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final projectAsync = ref.watch(projectNotifierProvider(clientId));
    final clientAsync = ref.watch(clientProvider(clientId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.projectTasks,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.1),
        actions: [
          projectAsync.when(
            data: (project) => project != null
                ? ExportPdfButton(project: project, clientId: clientId)
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client Info Header
            clientAsync.when(
              data: (client) => client != null
                  ? _ClientInfoCard(client: client)
                  : const SizedBox.shrink(),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('${l10n.errorLoadingClient}: $error'),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Project Summary
            projectAsync.when(
              data: (project) => project != null
                  ? ProjectSummaryCard(project: project)
                  : const SizedBox.shrink(),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('${l10n.errorLoadingProject}: $error'),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Project Stages
            projectAsync.when(
              data: (project) {
                if (project == null) {
                  return Center(
                    child: Text(l10n.projectNotFound),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.projectStages,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _showManageStagesDialog(context, project),
                              icon: const Icon(Icons.tune),
                              label: const Text('Manage'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () => _showAddStageDialog(context, ref),
                              icon: const Icon(Icons.add),
                              label: Text(l10n.addStage),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    ...project.stages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final stage = entry.value;

                      return Column(
                        children: [
                          StageCard(
                            stage: stage,
                            stageNumber: index + 1,
                            clientId: clientId,
                            onStageItemUpdate: (itemId, isCompleted, notes) {
                              ref.read(projectNotifierProvider(clientId).notifier)
                                  .updateStageItem(stage.id, itemId, isCompleted, notes);
                            },
                            onAddCustomItem: (title, isTextOnly) {
                              ref.read(projectNotifierProvider(clientId).notifier)
                                  .addCustomStageItem(stage.id, title, isTextOnly);
                            },
                            onDeleteItem: (itemId) {
                              ref.read(projectNotifierProvider(clientId).notifier)
                                  .deleteStageItem(stage.id, itemId);
                            },
                            onDeleteStage: () {
                              _showDeleteStageDialog(context, ref, stage.id, stage.title);
                            },
                            onEditStageTitle: (newTitle) {
                              ref.read(projectNotifierProvider(clientId).notifier)
                                  .updateStageTitle(stage.id, newTitle);
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('${l10n.error}: ${error.toString()}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(projectNotifierProvider(clientId)),
                      child: Text(l10n.tryAgain),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientInfoCard extends StatelessWidget {
  final Client client;

  const _ClientInfoCard({required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryBlue,
                        const Color(0xFF764BA2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3748),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        client.propertyAddress,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _InfoChip(
                    icon: Icons.badge,
                    label: 'ת.ז',
                    value: client.idNumber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoChip(
                    icon: Icons.business,
                    label: 'ועדה',
                    value: client.handlingCommittee,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue.withOpacity(0.1),
            const Color(0xFF764BA2).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3748),
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}