import 'package:equatable/equatable.dart';

enum QuestStatus {
  notStarted('not_started'),
  inProgress('in_progress'),
  completed('completed');

  final String value;
  const QuestStatus(this.value);

  String toJson() => value;

  static QuestStatus fromJson(String value) {
    return QuestStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => QuestStatus.notStarted,
    );
  }
}

enum QuestType {
  regular('regular'),
  revision('revision');

  final String value;
  const QuestType(this.value);

  String toJson() => value;

  static QuestType fromJson(String value) {
    return QuestType.values.firstWhere(
      (element) => element.value == value,
      orElse: () => QuestType.regular,
    );
  }
}

class QuestModel extends Equatable {
  final String id;
  final String userId;
  final String? goalId;
  final String? parentQuestId;
  final QuestType type;
  final String title;
  final String? description;
  final String? feedbackNote;
  final QuestStatus status;
  final int questOrder;
  final int xpReward;
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime? completedAt;

  const QuestModel({
    required this.id,
    required this.userId,
    this.goalId,
    this.parentQuestId,
    required this.type,
    required this.title,
    this.description,
    this.feedbackNote,
    required this.status,
    required this.questOrder,
    required this.xpReward,
    this.deadline,
    required this.createdAt,
    this.completedAt,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      goalId: json['goal_id'] as String?,
      parentQuestId: json['parent_quest_id'] as String?,
      type: QuestType.fromJson(json['type'] as String),
      title: json['title'] as String,
      description: json['description'] as String?,
      feedbackNote: json['feedback_note'] as String?,
      status: QuestStatus.fromJson(json['status'] as String),
      questOrder: (json['quest_order'] as num?)?.toInt() ?? 0,
      xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'user_id': userId,
      'type': type.toJson(),
      'title': title,
      'description': description,
      'feedback_note': feedbackNote,
      'status': status.toJson(),
      'quest_order': questOrder,
      'xp_reward': xpReward,
      'deadline': deadline?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    if (goalId != null && goalId!.isNotEmpty) {
      map['goal_id'] = goalId;
    }
    if (parentQuestId != null && parentQuestId!.isNotEmpty) {
      map['parent_quest_id'] = parentQuestId;
    }
    return map;
  }

  QuestModel copyWith({
    String? id,
    String? userId,
    String? goalId,
    String? parentQuestId,
    QuestType? type,
    String? title,
    String? description,
    String? feedbackNote,
    QuestStatus? status,
    int? questOrder,
    int? xpReward,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return QuestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      goalId: goalId ?? this.goalId,
      parentQuestId: parentQuestId ?? this.parentQuestId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      feedbackNote: feedbackNote ?? this.feedbackNote,
      status: status ?? this.status,
      questOrder: questOrder ?? this.questOrder,
      xpReward: xpReward ?? this.xpReward,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        goalId,
        parentQuestId,
        type,
        title,
        description,
        feedbackNote,
        status,
        questOrder,
        xpReward,
        deadline,
        createdAt,
        completedAt,
      ];
}
