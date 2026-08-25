import 'package:equatable/equatable.dart';
import 'package:raion_hackjam/data/models/thesis_journey_model.dart';

class GoalModel extends Equatable {
  final String id;
  final String journeyId;
  final String title;
  final ThesisStage thesisStage;
  final DateTime createdAt;

  const GoalModel({
    required this.id,
    required this.journeyId,
    required this.title,
    required this.thesisStage,
    required this.createdAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String,
      journeyId: json['journey_id'] as String,
      title: json['title'] as String,
      thesisStage: ThesisStage.fromJson(json['thesis_stage'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'journey_id': journeyId,
      'title': title,
      'thesis_stage': thesisStage.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  GoalModel copyWith({
    String? id,
    String? journeyId,
    String? title,
    ThesisStage? thesisStage,
    DateTime? createdAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      journeyId: journeyId ?? this.journeyId,
      title: title ?? this.title,
      thesisStage: thesisStage ?? this.thesisStage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        journeyId,
        title,
        thesisStage,
        createdAt,
      ];
}
