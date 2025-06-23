import 'package:app/model/generic/base_entity_model.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/museum/audio/audio_guide_model.dart';
import 'package:app/model/museum/audio/audio_guide_section_model.dart';
import 'package:app/model/museum/visit/guided/guided_visit_number_of_participants_model.dart';
import 'package:app/model/museum/activity/museum_activity_model.dart';
import 'package:app/model/generic/people/staff/staff_member_model.dart';
import 'package:flutter/material.dart';

/// Represents a guided visit to a museum or exhibition.
/// A guided visit is a scheduled event led by a staff member.
///
/// @property id Unique identifier for the guided visit
/// @property activity The museum activity associated with this guided visit
/// @property guide Staff member conducting the guided visit
/// @property details Descriptive information about the guided visit
/// @property scheduledTime The time period during which the guided visit is scheduled
/// @property maxParticipants Maximum number of participants allowed for this guided visit
/// @property createdAt When this guided visit was created
/// @property updatedAt When this guided visit information was last updated
class GuidedVisitModel extends BaseEntityModel {
  final MuseumActivityModel activity;
  final StaffMemberModel guide;
  final DetailsModel details;
  final AudioGuideModel? audioGuide;
  final int maxParticipants;
  final List<AudioGuideSectionModel>? audioGuideSections;
  final GuidedVisitNumberOfParticipantsModel numberOfParticipants;
  final DateTimeRange scheduledTime;

  GuidedVisitModel(this.audioGuide, this.maxParticipants, this.audioGuideSections, {
    required super.id,
    required this.activity,
    required this.guide,
    required this.details,
    required this.scheduledTime,
    required this.numberOfParticipants,
    super.createdAt,
    required super.updatedAt,
  });
}
