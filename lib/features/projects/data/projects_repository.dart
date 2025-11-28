import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/domain/models/project.dart';
import '../../../shared/domain/project_template.dart';

class ProjectsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'projects';

  Future<Project?> getProjectByClient(String clientId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      // Only get projects for the current user
      final snapshot = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .where('client_id', isEqualTo: clientId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return Project.fromJson({...doc.data(), 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load project: $e');
    }
  }

  Future<Project> createDefaultProject(String clientId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      final defaultStages = ProjectTemplate.getDefaultStages();
      final now = DateTime.now();

      final projectData = {
        'client_id': clientId,
        'stages': defaultStages.map((stage) => stage.toJson()).toList(),
        'created_at': Timestamp.fromDate(now),
        'updated_at': Timestamp.fromDate(now),
        'user_id': user.uid, // Add user_id field
      };

      final docRef = await _firestore.collection(_collection).add(projectData);

      return Project(
        id: docRef.id,
        clientId: clientId,
        stages: defaultStages,
        createdAt: now,
        updatedAt: now,
        userId: user.uid,
      );
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  Future<void> updateProjectStageItem(
    String projectId,
    String stageId,
    String itemId,
    bool isCompleted,
    String notes,
  ) async {
    try {
      final project = await getProject(projectId);
      if (project == null) throw Exception('Project not found');

      final updatedStages = project.stages.map((stage) {
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

      await _firestore.collection(_collection).doc(projectId).update({
        'stages': updatedStages.map((stage) => stage.toJson()).toList(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update stage item: $e');
    }
  }

  Future<Project?> getProject(String projectId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(projectId).get();
      if (doc.exists) {
        return Project.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load project: $e');
    }
  }

  Stream<Project?> getProjectByClientStream(String clientId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(null);
    }

    // Only stream projects for the current user
    return _firestore
        .collection(_collection)
        .where('user_id', isEqualTo: user.uid)
        .where('client_id', isEqualTo: clientId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return Project.fromJson({...doc.data(), 'id': doc.id});
      }
      return null;
    });
  }

  Future<void> addCustomStageItem(
    String projectId,
    String stageId,
    String title,
    bool isTextOnly,
  ) async {
    try {
      final project = await getProject(projectId);
      if (project == null) throw Exception('Project not found');

      final newItemId = 'custom_${DateTime.now().millisecondsSinceEpoch}';
      final newItem = ProjectStageItem(
        id: newItemId,
        title: title,
        isTextOnly: isTextOnly,
      );

      final updatedStages = project.stages.map((stage) {
        if (stage.id == stageId) {
          return stage.copyWith(
            items: [...stage.items, newItem],
          );
        }
        return stage;
      }).toList();

      await _firestore.collection(_collection).doc(projectId).update({
        'stages': updatedStages.map((stage) => stage.toJson()).toList(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add custom item: $e');
    }
  }

  Future<void> deleteStageItem(
    String projectId,
    String stageId,
    String itemId,
  ) async {
    try {
      final project = await getProject(projectId);
      if (project == null) throw Exception('Project not found');

      final updatedStages = project.stages.map((stage) {
        if (stage.id == stageId) {
          final updatedItems = stage.items.where((item) => item.id != itemId).toList();
          return stage.copyWith(items: updatedItems);
        }
        return stage;
      }).toList();

      await _firestore.collection(_collection).doc(projectId).update({
        'stages': updatedStages.map((stage) => stage.toJson()).toList(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to delete stage item: $e');
    }
  }

  Future<List<Project>> getProjectsByClient(String clientId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('משתמש לא מחובר');
      }

      // Only get projects for the current user
      final snapshot = await _firestore
          .collection(_collection)
          .where('user_id', isEqualTo: user.uid)
          .where('client_id', isEqualTo: clientId)
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Project.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  Future<void> addStage(
    String projectId,
    String stageTitle,
  ) async {
    try {
      final project = await getProject(projectId);
      if (project == null) throw Exception('Project not found');

      final newStageId = 'stage_${DateTime.now().millisecondsSinceEpoch}';
      final newStage = ProjectStage(
        id: newStageId,
        title: stageTitle,
        items: [],
      );

      final updatedStages = [...project.stages, newStage];

      await _firestore.collection(_collection).doc(projectId).update({
        'stages': updatedStages.map((stage) => stage.toJson()).toList(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add stage: $e');
    }
  }

  Future<void> deleteStage(
    String projectId,
    String stageId,
  ) async {
    try {
      final project = await getProject(projectId);
      if (project == null) throw Exception('Project not found');

      final updatedStages = project.stages.where((stage) => stage.id != stageId).toList();

      await _firestore.collection(_collection).doc(projectId).update({
        'stages': updatedStages.map((stage) => stage.toJson()).toList(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to delete stage: $e');
    }
  }

  Future<void> updateStageTitle(
    String projectId,
    String stageId,
    String newTitle,
  ) async {
    try {
      final project = await getProject(projectId);
      if (project == null) throw Exception('Project not found');

      final updatedStages = project.stages.map((stage) {
        if (stage.id == stageId) {
          return stage.copyWith(title: newTitle);
        }
        return stage;
      }).toList();

      await _firestore.collection(_collection).doc(projectId).update({
        'stages': updatedStages.map((stage) => stage.toJson()).toList(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update stage title: $e');
    }
  }

  /// Reorder stages in a project
  Future<void> reorderStages(
    String projectId,
    List<String> stageIds,
  ) async {
    try {
      final project = await getProject(projectId);
      if (project == null) throw Exception('Project not found');

      // Create a map of stageId to stage
      final stageMap = {for (var stage in project.stages) stage.id: stage};

      // Reorder stages based on the provided order and update orderIndex
      final reorderedStages = <ProjectStage>[];
      for (var i = 0; i < stageIds.length; i++) {
        final stageId = stageIds[i];
        if (stageMap.containsKey(stageId)) {
          final stage = stageMap[stageId]!;
          reorderedStages.add(stage.copyWith(orderIndex: i));
        }
      }

      // Add any stages that were not in the reorder list (shouldn't happen)
      for (var stage in project.stages) {
        if (!stageIds.contains(stage.id)) {
          reorderedStages.add(stage);
        }
      }

      await _firestore.collection(_collection).doc(projectId).update({
        'stages': reorderedStages.map((stage) => stage.toJson()).toList(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to reorder stages: $e');
    }
  }

  /// Move a stage up in the order
  Future<void> moveStageUp(String projectId, String stageId) async {
    try {
      final project = await getProject(projectId);
      if (project == null) throw Exception('Project not found');

      // Sort stages by orderIndex
      final sortedStages = List<ProjectStage>.from(project.stages)
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      final currentIndex = sortedStages.indexWhere((s) => s.id == stageId);
      if (currentIndex <= 0) return; // Can't move up if at top

      // Swap with previous stage
      final stageIds = sortedStages.map((s) => s.id).toList();
      final temp = stageIds[currentIndex];
      stageIds[currentIndex] = stageIds[currentIndex - 1];
      stageIds[currentIndex - 1] = temp;

      await reorderStages(projectId, stageIds);
    } catch (e) {
      throw Exception('Failed to move stage up: $e');
    }
  }

  /// Move a stage down in the order
  Future<void> moveStageDown(String projectId, String stageId) async {
    try {
      final project = await getProject(projectId);
      if (project == null) throw Exception('Project not found');

      // Sort stages by orderIndex
      final sortedStages = List<ProjectStage>.from(project.stages)
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      final currentIndex = sortedStages.indexWhere((s) => s.id == stageId);
      if (currentIndex >= sortedStages.length - 1) return; // Can't move down if at bottom

      // Swap with next stage
      final stageIds = sortedStages.map((s) => s.id).toList();
      final temp = stageIds[currentIndex];
      stageIds[currentIndex] = stageIds[currentIndex + 1];
      stageIds[currentIndex + 1] = temp;

      await reorderStages(projectId, stageIds);
    } catch (e) {
      throw Exception('Failed to move stage down: $e');
    }
  }
}