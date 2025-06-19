import 'package:app/model/generic/base_entity_model.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/museum/museumActivity/museum_activity_model.dart';
import 'package:app/model/generic/people/staff/staff_member_model.dart';
import 'package:flutter/material.dart';

/// Represents an educational visit organized for schools or educational institutions.
/// Educational visits typically have specific learning objectives and educational content.
///
/// @property id Unique identifier for the educational visit
/// @property activity The museum activity associated with this educational visit
/// @property educator Staff member leading the educational visit
/// @property details Descriptive information about the educational visit
/// @property scheduledTime The time period during which the educational visit is scheduled
/// @property ageGroup Target age group for the educational visit (e.g., "6-8 years", "high school")
/// @property educationalLevel Educational level this visit is designed for (e.g., "elementary", "middle school")
/// @property maxParticipants Maximum number of participants allowed for this educational visit
/// @property createdAt When this educational visit was created
/// @property updatedAt When this educational visit information was last updated
class EducationalVisitModel extends BaseEntityModel {
  final MuseumActivityModel labActivity;
  final StaffMemberModel educator;
  final DetailsModel details;
  final DateTimeRange scheduledTime;
  final String ageGroup;
  final String educationalLevel;
  final int maxParticipants;

  EducationalVisitModel({
    required super.id,
    required this.labActivity,
    required this.educator,
    required this.details,
    required this.scheduledTime,
    required this.ageGroup,
    required this.educationalLevel,
    required this.maxParticipants,
    super.createdAt,
    required super.updatedAt,
  });
}
