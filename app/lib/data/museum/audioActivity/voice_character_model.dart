import 'package:app/data/generic/base_entity_model.dart';
import 'package:app/data/generic/details_model.dart';

/// Represents a voice character used for audio narration.
/// Voice characters have distinct personalities and traits for different audio content.
///
/// @property id Unique identifier for the voice character
/// @property name Name of the voice character
/// @property description Description of the voice character's traits and personality
/// @property actorName Name of the voice actor/actress performing this character
/// @property languageCode ISO language code for the language this character speaks
/// @property createdAt When this voice character was created
/// @property updatedAt When this voice character information was last updated
class VoiceCharacterModel extends BaseEntityModel {
  final DetailsModel details;

  VoiceCharacterModel({
    required super.id,
    required this.details,
    super.createdAt,
    required super.updatedAt,
  });
}
