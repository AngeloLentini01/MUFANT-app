import 'package:app/data/generic/base_entity_model.dart';
import 'package:app/data/generic/details_model.dart';
import 'package:app/data/generic/supported_language_model.dart';
import 'package:app/data/museum/audioActivity/audio_guide_model.dart';
import 'package:app/data/museum/audioActivity/voice_character_model.dart';

/// Represents a section of an audio guide.
/// Each audio guide is divided into sections, each covering a specific exhibit or topic.
///
/// @property id Unique identifier for the audio guide section
/// @property audioGuide The parent audio guide this section belongs to
/// @property title Title of this section
/// @property order Numeric position of this section within the overall audio guide
/// @property duration Duration of this section in seconds
/// @property audioFilePath Path to the audio file for this section
/// @property transcript Text transcript of the audio content
/// @property voiceCharacter The character voice used for narration
/// @property createdAt When this section was created
/// @property updatedAt When this section information was last updated
class AudioGuideSectionModel extends BaseEntityModel {
  final AudioGuideModel audioGuide;
  final DetailsModel details;
  final int stepNumber;
  final String transcript;
  final SupportedLanguageModel language;
  final VoiceCharacterModel voiceCharacter;

  AudioGuideSectionModel({
    required super.id,
    required this.audioGuide,
    required this.details,
    required this.stepNumber,
    required this.transcript,
    required this.language,
    required this.voiceCharacter,
    super.createdAt,
    required super.updatedAt,
  });
}
