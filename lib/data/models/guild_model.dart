import 'package:equatable/equatable.dart';
import 'package:raion_hackjam/core/constants/app_assets.dart';

class GuildModel extends Equatable {
  final String id;
  final String name;
  final String code;
  final String creatorId;
  final String description;
  final String iconUrl;
  final DateTime createdAt;

  const GuildModel({
    required this.id,
    required this.name,
    required this.code,
    required this.creatorId,
    this.description = 'Learn, Connect, and Grow Together',
    this.iconUrl = AppAssets.skullSide,
    required this.createdAt,
  });

  factory GuildModel.fromJson(Map<String, dynamic> json) {
    return GuildModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      creatorId: json['creator_id'] as String,
      description: json['description'] as String? ?? 'Learn, Connect, and Grow Together',
      iconUrl: json['icon_url'] as String? ?? AppAssets.skullSide,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'code': code,
      'creator_id': creatorId,
      'description': description,
      'icon_url': iconUrl,
      'created_at': createdAt.toIso8601String(),
    };
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }

  GuildModel copyWith({
    String? id,
    String? name,
    String? code,
    String? creatorId,
    String? description,
    String? iconUrl,
    DateTime? createdAt,
  }) {
    return GuildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      creatorId: creatorId ?? this.creatorId,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        creatorId,
        description,
        iconUrl,
        createdAt,
      ];
}
