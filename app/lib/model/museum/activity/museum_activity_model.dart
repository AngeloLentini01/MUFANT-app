import 'package:app/model/generic/details_model.dart';
import 'package:flutter/material.dart';
import 'package:ulid/ulid.dart';
import 'type_of_museum_activity_model.dart';

/// Represents a specific activity available at a museum.
/// Activities can include exhibits, guided tours, workshops, etc.
///
/// @property id Unique identifier for the museum activity
/// @property location Physical location where the activity takes place
/// @property details Descriptive information about the activity
/// @property type The category of museum activity
/// @property activeTimePeriod Time period during which this activity is available
class MuseumActivityModel {
  final Ulid id;
  final String location;
  final DetailsModel details;
  final TypeOfMuseumActivityModel type;
  final DateTimeRange activeTimePeriod;

  const MuseumActivityModel({
    required this.id,
    required this.location,
    required this.details,
    required this.type,
    required this.activeTimePeriod,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MuseumActivityModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          location == other.location &&
          details == other.details &&
          type == other.type &&
          activeTimePeriod == other.activeTimePeriod;

  @override
  int get hashCode =>
      id.hashCode ^
      location.hashCode ^
      details.hashCode ^
      type.hashCode ^
      activeTimePeriod.hashCode;

  @override
  String toString() =>
      'MuseumActivityModel(id: $id, location: $location, details: $details, '
      'type: $type, activeTimePeriod: $activeTimePeriod)';

  MuseumActivityModel copyWith({
    Ulid? id,
    String? location,
    DetailsModel? details,
    TypeOfMuseumActivityModel? type,
    DateTimeRange? activeTimePeriod,
  }) {
    return MuseumActivityModel(
      id: id ?? this.id,
      location: location ?? this.location,
      details: details ?? this.details,
      type: type ?? this.type,
      activeTimePeriod: activeTimePeriod ?? this.activeTimePeriod,
    );
  }
}
