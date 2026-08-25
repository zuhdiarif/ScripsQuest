import 'package:equatable/equatable.dart';

class GuildLeaderboardModel extends Equatable {
  final String guildId;
  final String userId;
  final String username;
  final String? avatarUrl;
  final int level;
  final int totalXp;
  final int rank;

  const GuildLeaderboardModel({
    required this.guildId,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.level,
    required this.totalXp,
    required this.rank,
  });

  factory GuildLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return GuildLeaderboardModel(
      guildId: json['guild_id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      level: (json['level'] as num?)?.toInt() ?? 1,
      totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guild_id': guildId,
      'user_id': userId,
      'username': username,
      'avatar_url': avatarUrl,
      'level': level,
      'total_xp': totalXp,
      'rank': rank,
    };
  }

  GuildLeaderboardModel copyWith({
    String? guildId,
    String? userId,
    String? username,
    String? avatarUrl,
    int? level,
    int? totalXp,
    int? rank,
  }) {
    return GuildLeaderboardModel(
      guildId: guildId ?? this.guildId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      totalXp: totalXp ?? this.totalXp,
      rank: rank ?? this.rank,
    );
  }

  @override
  List<Object?> get props => [
        guildId,
        userId,
        username,
        avatarUrl,
        level,
        totalXp,
        rank,
      ];
}
