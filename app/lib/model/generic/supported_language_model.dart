import 'package:app/model/generic/base_entity_model.dart';
import 'package:ulid/ulid.dart';

/// Represents a language supported by the museum for various content.
/// This model is used to track languages available for audio guides, descriptions, etc.
///
/// @property id Unique identifier for the supported language
/// @property languageCode ISO language code (e.g., "en", "fr", "es")
/// @property languageName Full name of the language (e.g., "English", "French", "Spanish")
/// @property isActive Whether this language is currently available/active
/// @property createdAt When this language was added to the system
/// @property updatedAt When this language information was last updated
class SupportedLanguageModel extends BaseEntityModel {
  final String languageCode;
  final String languageName;
  final bool isActive;

  SupportedLanguageModel({
    required super.id,
    required this.languageCode,
    required this.languageName,
    required this.isActive,
    super.createdAt,
    required super.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupportedLanguageModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          languageCode == other.languageCode &&
          languageName == other.languageName &&
          isActive == other.isActive &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      languageCode.hashCode ^
      languageName.hashCode ^
      isActive.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'SupportedLanguageModel(id: $id, languageCode: $languageCode, '
      'languageName: $languageName, isActive: $isActive, '
      'createdAt: $createdAt, updatedAt: $updatedAt)';

  SupportedLanguageModel copyWith({
    Ulid? id,
    String? languageCode,
    String? languageName,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupportedLanguageModel(
      id: id ?? this.id,
      languageCode: languageCode ?? this.languageCode,
      languageName: languageName ?? this.languageName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
