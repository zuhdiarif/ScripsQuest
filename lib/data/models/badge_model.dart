import 'package:equatable/equatable.dart';

class BadgeModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String requirement;
  final String? iconUrl;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.requirement,
    this.iconUrl,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      requirement: json['requirement'] as String,
      iconUrl: json['icon_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'requirement': requirement,
      'icon_url': iconUrl,
    };
  }

  BadgeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? requirement,
    String? iconUrl,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      requirement: requirement ?? this.requirement,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        requirement,
        iconUrl,
      ];
}
