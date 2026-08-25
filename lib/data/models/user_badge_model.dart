import 'package:equatable/equatable.dart';

class UserBadgeModel extends Equatable {
  final String userId;
  final String badgeId;
  final DateTime unlockedAt;

  const UserBadgeModel({
    required this.userId,
    required this.badgeId,
    required this.unlockedAt,
  });

  factory UserBadgeModel.fromJson(Map<String, dynamic> json) {
    return UserBadgeModel(
      userId: json['user_id'] as String,
      badgeId: json['badge_id'] as String,
      unlockedAt: DateTime.parse(json['unlocked_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'badge_id': badgeId,
      'unlocked_at': unlockedAt.toIso8601String(),
    };
  }

  UserBadgeModel copyWith({
    String? userId,
    String? badgeId,
    DateTime? unlockedAt,
  }) {
    return UserBadgeModel(
      userId: userId ?? this.userId,
      badgeId: badgeId ?? this.badgeId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        badgeId,
        unlockedAt,
      ];
}
