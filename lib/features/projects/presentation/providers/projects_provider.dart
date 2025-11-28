import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../../shared/domain/models/project.dart';
import '../../data/projects_repository.dart';

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  return ProjectsRepository();
});

final projectByClientProvider = StreamProvider.family<Project?, String>((ref, clientId) {
  final repository = ref.watch(projectsRepositoryProvider);
  ref.keepAlive(); // Keep stream alive to prevent reconnection lag
  return repository.getProjectByClientStream(clientId);
});

final projectProvider = FutureProvider.family<Project?, String>((ref, projectId) {
  final repository = ref.watch(projectsRepositoryProvider);
  return repository.getProject(projectId);
});

class ProjectNotifier extends StateNotifier<AsyncValue<Project?>> {
  final ProjectsRepository _repository;
  final String clientId;
  Timer? _debounceTimer;
  final Map<String, Timer> _pendingUpdates = {};

  ProjectNotifier(this._repository, this.clientId) : super(const AsyncValue.loading()) {
    _loadProject();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    for (final timer in _pendingUpdates.values) {
      timer.cancel();
    }
    _pendingUpdates.clear();
    super.dispose();
  }

  Future<void> _loadProject() async {
    try {
      final project = await _repository.getProjectByClient(clientId);
      if (project == null) {
        // Create default project if none exists
        final newProject = await _repository.createDefaultProject(clientId);
        state = AsyncValue.data(newProject);
      } else {
        state = AsyncValue.data(project);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateStageItem(
    String stageId,
    String itemId,
    bool isCompleted,
    String notes,
  ) async {
    final currentProject = state.value;
    if (currentProject == null) return;

    // OPTIMISTIC UPDATE: Update UI immediately
    final updatedStages = currentProject.stages.map((stage) {
      if (stage.id == stageId) {
        final updatedItems = stage.items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(
              isCompleted: isCompleted,
              notes: notes,
            );
          }
          return item;
        }).toList();
        return stage.copyWith(items: updatedItems);
      }
      return stage;
    }).toList();

    final updatedProject = currentProject.copyWith(
      stages: updatedStages,
      updatedAt: DateTime.now(),
    );

    state = AsyncValue.data(updatedProject);

    // DEBOUNCED DATABASE UPDATE: Save to database after delay
    final updateKey = '${stageId}_$itemId';
    _pendingUpdates[updateKey]?.cancel();
    _pendingUpdates[updateKey] = Timer(const Duration(milliseconds: 500), () async {
      try {
        await _repository.updateProjectStageItem(
          currentProject.id,
          stageId,
          itemId,
          isCompleted,
          notes,
        );
        _pendingUpdates.remove(updateKey);
      } catch (e, stack) {
        // Revert optimistic update on error
        await _loadProject();
        _pendingUpdates.remove(updateKey);
      }
    });
  }

  Future<void> addCustomStageItem(
    String stageId,
    String title,
    bool isTextOnly,
  ) async {
    final currentProject = state.value;
    if (currentProject == null) return;

    try {
      await _repository.addCustomStageItem(
        currentProject.id,
        stageId,
        title,
        isTextOnly,
      );
      await _loadProject(); // Reload to get updated data
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteStageItem(String stageId, String itemId) async {
    final currentProject = state.value;
    if (currentProject == null) return;

    try {
      await _repository.deleteStageItem(
        currentProject.id,
        stageId,
        itemId,
      );
      await _loadProject(); // Reload to get updated data
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addStage(String stageTitle) async {
    final currentProject = state.value;
    if (currentProject == null) return;

    try {
      await _repository.addStage(
        currentProject.id,
        stageTitle,
      );
      await _loadProject(); // Reload to get updated data
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteStage(String stageId) async {
    final currentProject = state.value;
    if (currentProject == null) return;

    try {
      await _repository.deleteStage(
        currentProject.id,
        stageId,
      );
      await _loadProject(); // Reload to get updated data
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateStageTitle(String stageId, String newTitle) async {
    final currentProject = state.value;
    if (currentProject == null) return;

    try {
      await _repository.updateStageTitle(
        currentProject.id,
        stageId,
        newTitle,
      );
      await _loadProject(); // Reload to get updated data
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final projectNotifierProvider = StateNotifierProvider.family<ProjectNotifier, AsyncValue<Project?>, String>(
  (ref, clientId) {
    final repository = ref.watch(projectsRepositoryProvider);
    return ProjectNotifier(repository, clientId);
  },
);