import 'package:equatable/equatable.dart';

class StreakHistoryModel extends Equatable {
  final String id;
  final String userId;
  final DateTime activeDate;

  const StreakHistoryModel({
    required this.id,
    required this.userId,
    required this.activeDate,
  });

  factory StreakHistoryModel.fromJson(Map<String, dynamic> json) {
    return StreakHistoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      activeDate: DateTime.parse(json['active_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'active_date': activeDate.toIso8601String(),
    };
  }

  StreakHistoryModel copyWith({
    String? id,
    String? userId,
    DateTime? activeDate,
  }) {
    return StreakHistoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      activeDate: activeDate ?? this.activeDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        activeDate,
      ];
}
