import 'base_entity_model.dart';
import 'package:ulid/ulid.dart';

/// Provides common descriptive information for various entities.
/// Extends BaseEntityModel to include creation and update timestamps.
///
/// @property name The name or title of the entity
/// @property description A detailed description of the entity
/// @property notes Additional information or notes about the entity
/// @property imageUrlOrPath Optional path or URL to an image associated with this entity
/// @property createdAt When this entity was created, defaults to current time
/// @property updatedAt When this entity was last updated
class DetailsModel extends BaseEntityModel {
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'notes': notes,
    'imageUrlOrPath': imageUrlOrPath,
    'id': id?.toString(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory DetailsModel.fromJson(Map<String, dynamic> json) => DetailsModel(
    name: json['name'] as String,
    description: json['description'] as String?,
    notes: json['notes'] as String?,
    imageUrlOrPath: json['imageUrlOrPath'] as String?,
    id: json['id'] != null ? Ulid.parse(json['id'] as String) : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : null,
  );
  final String name;
  final String? description;
  final String? notes;
  final String? imageUrlOrPath;

  DetailsModel({
    required this.name,
    this.description,
    this.notes,
    this.imageUrlOrPath,
    super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailsModel &&
          name == other.name &&
          description == other.description &&
          notes == other.notes &&
          imageUrlOrPath == other.imageUrlOrPath &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      notes.hashCode ^
      (imageUrlOrPath?.hashCode ?? 0) ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'DetailsModel(name: $name, description: $description, '
      'notes: $notes, imageUrlOrPath: $imageUrlOrPath, '
      'createdAt: $createdAt, updatedAt: $updatedAt)';

  /// Creates a copy of this DetailsModel with the given fields replaced with the new values
  DetailsModel copyWith({
    String? name,
    String? description,
    String? notes,
    Object? imageUrlOrPath = const Object(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DetailsModel(
      id: id, // ID should not change
      name: name ?? this.name,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      imageUrlOrPath: imageUrlOrPath != const Object()
          ? (imageUrlOrPath as String?)
          : this.imageUrlOrPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
