import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String id;
  final String username;
  final String? avatarUrl;
  final int totalXp;
  final int level;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActiveDate;
  final String? guildId;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.totalXp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    this.guildId,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longest_streak'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['last_active_date'] != null
          ? DateTime.parse(json['last_active_date'] as String)
          : null,
      guildId: json['guild_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'total_xp': totalXp,
      'level': level,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_active_date': lastActiveDate?.toIso8601String(),
      'guild_id': guildId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    int? totalXp,
    int? level,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActiveDate,
    String? guildId,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      guildId: guildId ?? this.guildId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        avatarUrl,
        totalXp,
        level,
        currentStreak,
        longestStreak,
        lastActiveDate,
        guildId,
        createdAt,
      ];
}
