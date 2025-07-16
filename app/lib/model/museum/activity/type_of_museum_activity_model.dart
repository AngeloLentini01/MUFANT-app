import 'package:app/model/generic/details_model.dart';
import 'package:ulid/ulid.dart';

/// Represents a category of museum activities.
/// Examples might include "Guided Tour", "Interactive Exhibit", "Workshop", etc.
///
/// @property id Unique identifier for the activity type
/// @property details Descriptive information about the activity type
class TypeOfMuseumActivityModel {
  Map<String, dynamic> toJson() => {
    'id': id.toString(),
    'details': details.toJson(),
  };

  factory TypeOfMuseumActivityModel.fromJson(Map<String, dynamic> json) =>
      TypeOfMuseumActivityModel(
        id: Ulid.parse(json['id'] as String),
        details: DetailsModel.fromJson(json['details'] as Map<String, dynamic>),
      );
  final Ulid id;
  final DetailsModel details;

  const TypeOfMuseumActivityModel({required this.id, required this.details});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeOfMuseumActivityModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          details == other.details;

  @override
  int get hashCode => id.hashCode ^ details.hashCode;

  @override
  String toString() => 'TypeOfMuseumActivityModel(id: $id, details: $details)';

  TypeOfMuseumActivityModel copyWith({Ulid? id, DetailsModel? details}) {
    return TypeOfMuseumActivityModel(
      id: id ?? this.id,
      details: details ?? this.details,
    );
  }
}
