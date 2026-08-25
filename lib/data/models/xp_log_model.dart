import 'package:equatable/equatable.dart';

class XpLogModel extends Equatable {
  final String id;
  final String userId;
  final String? questId;
  final int xpAmount;
  final String reason;
  final DateTime createdAt;

  const XpLogModel({
    required this.id,
    required this.userId,
    this.questId,
    required this.xpAmount,
    required this.reason,
    required this.createdAt,
  });

  factory XpLogModel.fromJson(Map<String, dynamic> json) {
    return XpLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      questId: json['quest_id'] as String?,
      xpAmount: (json['xp_amount'] as num?)?.toInt() ?? 0,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'quest_id': questId,
      'xp_amount': xpAmount,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  XpLogModel copyWith({
    String? id,
    String? userId,
    String? questId,
    int? xpAmount,
    String? reason,
    DateTime? createdAt,
  }) {
    return XpLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      questId: questId ?? this.questId,
      xpAmount: xpAmount ?? this.xpAmount,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        questId,
        xpAmount,
        reason,
        createdAt,
      ];
}
