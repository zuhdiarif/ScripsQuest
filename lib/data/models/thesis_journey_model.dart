import 'package:equatable/equatable.dart';

enum ThesisStage {
  belumMulai('belum_mulai'),
  menentukanTopik('menentukan_topik'),
  proposal('proposal'),
  seminarProposal('seminar_proposal'),
  literatureReview('literature_review'),
  pengumpulanData('pengumpulan_data'),
  analisisData('analisis_data'),
  penulisan('penulisan'),
  revisi('revisi'),
  persiapanSidang('persiapan_sidang');

  final String value;
  const ThesisStage(this.value);

  String toJson() => value;

  static ThesisStage fromJson(String value) {
    return ThesisStage.values.firstWhere(
      (element) => element.value == value,
      orElse: () => ThesisStage.belumMulai,
    );
  }
}

enum JourneyStatus {
  active('active'),
  completed('completed');

  final String value;
  const JourneyStatus(this.value);

  String toJson() => value;

  static JourneyStatus fromJson(String value) {
    return JourneyStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => JourneyStatus.active,
    );
  }
}

class ThesisJourneyModel extends Equatable {
  final String id;
  final String userId;
  final ThesisStage stage;
  final String? topic;
  final String currentGoal;
  final JourneyStatus status;
  final DateTime createdAt;

  const ThesisJourneyModel({
    required this.id,
    required this.userId,
    required this.stage,
    this.topic,
    required this.currentGoal,
    required this.status,
    required this.createdAt,
  });

  factory ThesisJourneyModel.fromJson(Map<String, dynamic> json) {
    return ThesisJourneyModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      stage: ThesisStage.fromJson(json['stage'] as String),
      topic: json['topic'] as String?,
      currentGoal: json['current_goal'] as String,
      status: JourneyStatus.fromJson(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'stage': stage.toJson(),
      'topic': topic,
      'current_goal': currentGoal,
      'status': status.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  ThesisJourneyModel copyWith({
    String? id,
    String? userId,
    ThesisStage? stage,
    String? topic,
    String? currentGoal,
    JourneyStatus? status,
    DateTime? createdAt,
  }) {
    return ThesisJourneyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      stage: stage ?? this.stage,
      topic: topic ?? this.topic,
      currentGoal: currentGoal ?? this.currentGoal,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        stage,
        topic,
        currentGoal,
        status,
        createdAt,
      ];
}
