import 'package:flutter/material.dart';
import '../../../../shared/domain/models/project.dart';
import '../../data/projects_repository.dart';

class ManageStagesDialog extends StatefulWidget {
  final String projectId;
  final List<ProjectStage> stages;
  final VoidCallback onStagesUpdated;

  const ManageStagesDialog({
    super.key,
    required this.projectId,
    required this.stages,
    required this.onStagesUpdated,
  });

  @override
  State<ManageStagesDialog> createState() => _ManageStagesDialogState();
}

class _ManageStagesDialogState extends State<ManageStagesDialog> {
  late List<ProjectStage> _stages;
  final _projectsRepo = ProjectsRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Sort stages by orderIndex
    _stages = List<ProjectStage>.from(widget.stages)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Stages'),
      content: SizedBox(
        width: double.maxFinite,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ReorderableListView.builder(
                shrinkWrap: true,
                itemCount: _stages.length,
                onReorder: _onReorder,
                itemBuilder: (context, index) {
                  final stage = _stages[index];
                  return _buildStageItem(context, index, stage);
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildStageItem(BuildContext context, int index, ProjectStage stage) {
    return Card(
      key: ValueKey(stage.id),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle),
        ),
        title: Text(stage.title),
        subtitle: Text('${stage.items.length} items'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuOption(value, stage),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit Title'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuOption(String option, ProjectStage stage) {
    if (option == 'edit') {
      _showEditDialog(stage);
    } else if (option == 'delete') {
      _showDeleteConfirmation(stage);
    }
  }

  void _showEditDialog(ProjectStage stage) {
    final controller = TextEditingController(text: stage.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Stage Title'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Stage Title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  final index = _stages.indexWhere((s) => s.id == stage.id);
                  if (index != -1) {
                    _stages[index] = stage.copyWith(title: controller.text);
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(ProjectStage stage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Stage'),
        content: Text(
          'Are you sure you want to delete "${stage.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _stages.removeWhere((s) => s.id == stage.id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final stage = _stages.removeAt(oldIndex);
      _stages.insert(newIndex, stage);
    });
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    try {
      // Get the list of stage IDs in the new order
      final stageIds = _stages.map((s) => s.id).toList();

      // Get the list of stage IDs to delete
      final originalIds = widget.stages.map((s) => s.id).toList();
      final stageIdsToDelete = originalIds.where((id) => !stageIds.contains(id)).toList();

      // Reorder stages
      await _projectsRepo.reorderStages(widget.projectId, stageIds);

      // Delete removed stages
      for (final stageId in stageIdsToDelete) {
        await _projectsRepo.deleteStage(widget.projectId, stageId);
      }

      // Update edited titles
      for (var i = 0; i < _stages.length; i++) {
        final originalStage = widget.stages.firstWhere(
          (s) => s.id == _stages[i].id,
          orElse: () => _stages[i],
        );
        if (originalStage.title != _stages[i].title) {
          await _projectsRepo.updateStageTitle(
            widget.projectId,
            _stages[i].id,
            _stages[i].title,
          );
        }
      }

      if (mounted) {
        widget.onStagesUpdated();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stages updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating stages: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
