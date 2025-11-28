class ProjectStageItem {
  final String id;
  final String title;
  final bool isCompleted;
  final String notes;
  final bool isTextOnly;

  const ProjectStageItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.notes = '',
    this.isTextOnly = false,
  });

  factory ProjectStageItem.fromJson(Map<String, dynamic> json) {
    return ProjectStageItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      isCompleted: json['is_completed'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      isTextOnly: json['is_text_only'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
      'notes': notes,
      'is_text_only': isTextOnly,
    };
  }

  ProjectStageItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? notes,
    bool? isTextOnly,
  }) {
    return ProjectStageItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      isTextOnly: isTextOnly ?? this.isTextOnly,
    );
  }
}

class ProjectStage {
  final String id;
  final String title;
  final List<ProjectStageItem> items;
  final int orderIndex; // Order in the project (for reordering)

  const ProjectStage({
    required this.id,
    required this.title,
    required this.items,
    this.orderIndex = 0,
  });

  factory ProjectStage.fromJson(Map<String, dynamic> json) {
    return ProjectStage(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => ProjectStageItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      orderIndex: json['order_index'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'items': items.map((item) => item.toJson()).toList(),
      'order_index': orderIndex,
    };
  }

  ProjectStage copyWith({
    String? id,
    String? title,
    List<ProjectStageItem>? items,
    int? orderIndex,
  }) {
    return ProjectStage(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? this.items,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  double get completionPercentage {
    if (items.isEmpty) return 0.0;
    final completedItems = items.where((item) => !item.isTextOnly && item.isCompleted).length;
    final totalItems = items.where((item) => !item.isTextOnly).length;
    return totalItems > 0 ? completedItems / totalItems : 0.0;
  }
}

class Project {
  final String id;
  final String clientId;
  final List<ProjectStage> stages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId; // Owner of this project

  const Project({
    required this.id,
    required this.clientId,
    required this.stages,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String? ?? '',
      clientId: json['client_id'] as String? ?? '',
      stages: (json['stages'] as List<dynamic>? ?? [])
          .map((stage) => ProjectStage.fromJson(stage as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] != null
          ? (json['created_at'] is String
              ? DateTime.parse(json['created_at'] as String)
              : (json['created_at'] as dynamic).toDate())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? (json['updated_at'] is String
              ? DateTime.parse(json['updated_at'] as String)
              : (json['updated_at'] as dynamic).toDate())
          : DateTime.now(),
      userId: json['user_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'stages': stages.map((stage) => stage.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_id': userId,
    };
  }

  Project copyWith({
    String? id,
    String? clientId,
    List<ProjectStage>? stages,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return Project(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      stages: stages ?? this.stages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  double get overallCompletionPercentage {
    if (stages.isEmpty) return 0.0;
    final totalCompletion = stages.fold(0.0, (sum, stage) => sum + stage.completionPercentage);
    return totalCompletion / stages.length;
  }
}