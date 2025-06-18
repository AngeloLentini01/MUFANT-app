import 'package:app/data/generic/base_entity_model.dart';
import 'package:app/data/generic/details_model.dart';
import 'package:app/data/museum/museumActivity/museum_activity_model.dart';

/// Represents an audio guide available for museum visitors.
/// Audio guides provide narrated information about exhibits and attractions.
///
/// @property id Unique identifier for the audio guide
/// @property activity The museum activity this audio guide is for
/// @property details Descriptive information about the audio guide
/// @property totalDuration Total duration of the audio guide in seconds
/// @property createdAt When this audio guide was created
/// @property updatedAt When this audio guide information was last updated
class AudioGuideModel extends BaseEntityModel {
  final MuseumActivityModel activity;
  final DetailsModel details;
  final int totalDuration; // Duration in seconds

  AudioGuideModel({
    required super.id,
    required this.activity,
    required this.details,
    required this.totalDuration,
    super.createdAt,
    required super.updatedAt,
  });
}
