import 'package:flutter/material.dart';
import '../../../../shared/domain/models/project.dart';
import '../../../../core/theme/app_theme.dart';

class ProjectSummaryCard extends StatelessWidget {
  final Project project;

  const ProjectSummaryCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final completionPercentage = project.overallCompletionPercentage;
    final completedStages = project.stages
        .where((stage) => stage.completionPercentage == 1.0)
        .length;
    final totalStages = project.stages.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.doneColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.checklist,
                    color: AppTheme.doneColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'סיכום פרויקט',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'נוצר: ${_formatDate(project.createdAt)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(completionPercentage * 100).round()}%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800], // Simple dark grey
                      ),
                    ),
                    Text(
                      'הושלם',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'התקדמות כללית',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$completedStages מתוך $totalStages שלבים',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: completionPercentage,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(completionPercentage),
                  ),
                  minHeight: 8,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stage Status Summary
            Wrap(
              spacing: 12,
              children: project.stages.asMap().entries.map((entry) {
                final index = entry.key;
                final stage = entry.value;
                final progress = stage.completionPercentage;

                return _StageStatusChip(
                  stageNumber: index + 1,
                  title: stage.title,
                  progress: progress,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage == 1.0) return Colors.grey[700]!;
    if (percentage >= 0.5) return Colors.grey[600]!;
    return Colors.grey[500]!;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StageStatusChip extends StatelessWidget {
  final int stageNumber;
  final String title;
  final double progress;

  const _StageStatusChip({
    required this.stageNumber,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = progress == 1.0;
    final color = isComplete ? Colors.grey[700]! : Colors.grey[400]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isComplete
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : Text(
                      '$stageNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}