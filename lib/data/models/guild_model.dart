import 'package:equatable/equatable.dart';

class GuildModel extends Equatable {
  final String id;
  final String name;
  final String code;
  final String creatorId;
  final DateTime createdAt;

  const GuildModel({
    required this.id,
    required this.name,
    required this.code,
    required this.creatorId,
    required this.createdAt,
  });

  factory GuildModel.fromJson(Map<String, dynamic> json) {
    return GuildModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      creatorId: json['creator_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'creator_id': creatorId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  GuildModel copyWith({
    String? id,
    String? name,
    String? code,
    String? creatorId,
    DateTime? createdAt,
  }) {
    return GuildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        creatorId,
        createdAt,
      ];
}
