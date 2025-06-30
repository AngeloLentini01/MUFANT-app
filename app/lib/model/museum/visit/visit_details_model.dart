import 'package:app/model/generic/base_entity_model.dart';
import 'package:app/model/museum/activity/museum_activity_model.dart';
import 'package:flutter/material.dart';

/// Represents details about a visit to a museum.
/// This model tracks information about individual visits for analytics and reporting.
///
/// @property id Unique identifier for the visit details
/// @property visitor Information about the visitor
/// @property activity The museum activity that was visited
/// @property visitTime Time period during which the visit took place
/// @property satisfactionRating Optional rating provided by the visitor (1-5 scale)
/// @property feedback Optional feedback provided by the visitor
/// @property createdAt When this record was created
/// @property updatedAt When this record was last updated
class VisitDetailsModel extends BaseEntityModel {
  final MuseumActivityModel activity;
  final DateTimeRange visitTime;

  VisitDetailsModel({
    required super.id,
    required this.activity,
    required this.visitTime,
    super.createdAt,
    required super.updatedAt,
  });
}
