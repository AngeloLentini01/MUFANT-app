import 'package:ulid/ulid.dart';

/// Base model class that provides creation and update timestamps.
/// Serves as a foundation for all entity models in the system.
///
/// @property createdAt When this entity was created, defaults to current time
/// @property updatedAt When this entity was last updated
class BaseEntityModel {
  final Ulid? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseEntityModel({
    required this.id,
    DateTime? createdAt,
    required this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
