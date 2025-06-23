import 'package:app/model/generic/base_entity_model.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/museum/activity/museum_activity_model.dart';
import 'package:app/model/generic/supported_language_model.dart';
import 'package:ulid/ulid.dart';

/// Represents additional detailed information about a museum activity.
/// This model contains language-specific information and supplementary details.
///
/// @property id Unique identifier for the museum activity details
/// @property activity The museum activity these details are for
/// @property language The language in which these details are provided
/// @property extendedDescription An expanded description of the activity
/// @property accessibilityInformation Information about accessibility features for this activity
/// @property highlights Key highlights or points of interest about this activity
/// @property createdAt When these details were created
/// @property updatedAt When these details were last updated
class MuseumActivityDetailsModel extends BaseEntityModel {
  final MuseumActivityModel activity;
  final SupportedLanguageModel language;
  final DetailsModel details;

  MuseumActivityDetailsModel({
    required super.id,
    required this.activity,
    required this.language,
    required this.details,
    super.createdAt,
    required super.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MuseumActivityDetailsModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          activity == other.activity &&
          language == other.language &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      activity.hashCode ^
      language.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'MuseumActivityDetailsModel(id: $id, activity: $activity, '
      'language: $language, details: $details, createdAt: $createdAt, updatedAt: $updatedAt)';

  MuseumActivityDetailsModel copyWith({
    Ulid? id,
    MuseumActivityModel? activity,
    SupportedLanguageModel? language,
    DetailsModel? details,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MuseumActivityDetailsModel(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      language: language ?? this.language,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
