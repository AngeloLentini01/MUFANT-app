import 'package:app/model/generic/supported_language_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulid/ulid.dart';

void main() {
  group('SupportedLanguageModel', () {
    test('Constructor - Basic creation', () {
      // Description: Tests that a SupportedLanguageModel can be created with all required parameters
      // Steps:
      // 1. Create a SupportedLanguageModel with all required parameters
      // 2. Verify all properties match the provided values
      // Expected Result: All properties should match the provided values

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const languageCode = 'en';
      const languageName = 'English';
      const isActive = true;

      // Act
      final model = SupportedLanguageModel(
        id: id,
        languageCode: languageCode,
        languageName: languageName,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Assert
      expect(model.id, equals(id));
      expect(model.languageCode, equals(languageCode));
      expect(model.languageName, equals(languageName));
      expect(model.isActive, equals(isActive));
      expect(model.createdAt, equals(createdAt));
      expect(model.updatedAt, equals(updatedAt));
    });

    test('Constructor - Default createdAt', () {
      // Description: Tests that a SupportedLanguageModel can be created with default createdAt
      // Steps:
      // 1. Create a SupportedLanguageModel without providing createdAt
      // 2. Verify createdAt is set to a time close to now
      // Expected Result: createdAt should be within a few milliseconds of current time

      // Arrange
      final id = Ulid();
      final updatedAt = DateTime(2025, 6, 18);
      const languageCode = 'en';
      const languageName = 'English';
      const isActive = true;
      final beforeCreation = DateTime.now();

      // Act
      final model = SupportedLanguageModel(
        id: id,
        languageCode: languageCode,
        languageName: languageName,
        isActive: isActive,
        updatedAt: updatedAt,
      );
      final afterCreation = DateTime.now();

      // Assert
      expect(
        model.createdAt.isAfter(beforeCreation) ||
            model.createdAt.isAtSameMomentAs(beforeCreation),
        isTrue,
        reason: 'createdAt should be after or equal to beforeCreation time',
      );
      expect(
        model.createdAt.isBefore(afterCreation) ||
            model.createdAt.isAtSameMomentAs(afterCreation),
        isTrue,
        reason: 'createdAt should be before or equal to afterCreation time',
      );
    });

    test('equality - identical objects', () {
      // Description: Tests that two SupportedLanguageModel instances with the same property values are considered equal
      // Steps:
      // 1. Create two SupportedLanguageModel instances with identical property values
      // 2. Compare them for equality
      // Expected Result: Models should be considered equal

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const languageCode = 'en';
      const languageName = 'English';
      const isActive = true;

      // Act
      final model1 = SupportedLanguageModel(
        id: id,
        languageCode: languageCode,
        languageName: languageName,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final model2 = SupportedLanguageModel(
        id: id,
        languageCode: languageCode,
        languageName: languageName,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Assert
      expect(model1 == model2, isTrue);
    });

    test('equality - different values', () {
      // Description: Tests that two SupportedLanguageModel instances with different property values are not considered equal
      // Steps:
      // 1. Create two SupportedLanguageModel instances with different languageCode values
      // 2. Compare them for equality
      // Expected Result: Models should not be considered equal

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const languageName = 'English';
      const isActive = true;

      // Act
      final model1 = SupportedLanguageModel(
        id: id,
        languageCode: 'en',
        languageName: languageName,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final model2 = SupportedLanguageModel(
        id: id,
        languageCode: 'es',
        languageName: languageName,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Assert
      expect(model1 == model2, isFalse);
    });

    test('toString returns formatted string', () {
      // Description: Tests that toString returns a properly formatted string representation
      // Steps:
      // 1. Create a SupportedLanguageModel
      // 2. Call toString
      // 3. Verify result contains all property values
      // Expected Result: toString result should contain all property values

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const languageCode = 'en';
      const languageName = 'English';
      const isActive = true;

      // Act
      final model = SupportedLanguageModel(
        id: id,
        languageCode: languageCode,
        languageName: languageName,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final toString = model.toString();

      // Assert
      expect(toString, contains(id.toString()));
      expect(toString, contains(languageCode));
      expect(toString, contains(languageName));
      expect(toString, contains(isActive.toString()));
      expect(toString, contains(createdAt.toString()));
      expect(toString, contains(updatedAt.toString()));
    });

    test('copyWith - change single property', () {
      // Description: Tests that copyWith creates a new instance with one changed property
      // Steps:
      // 1. Create a SupportedLanguageModel
      // 2. Create a copy with a changed languageName
      // 3. Verify only the languageName was changed
      // Expected Result: Only the languageName property should be different

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const languageCode = 'en';
      const languageName = 'English';
      const isActive = true;

      // Act
      final original = SupportedLanguageModel(
        id: id,
        languageCode: languageCode,
        languageName: languageName,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final copy = original.copyWith(languageName: 'English (US)');

      // Assert
      expect(copy.id, equals(original.id));
      expect(copy.languageCode, equals(original.languageCode));
      expect(copy.languageName, equals('English (US)'));
      expect(copy.isActive, equals(original.isActive));
      expect(copy.createdAt, equals(original.createdAt));
      expect(copy.updatedAt, equals(original.updatedAt));
    });

    test('copyWith - change multiple properties', () {
      // Description: Tests that copyWith creates a new instance with multiple changed properties
      // Steps:
      // 1. Create a SupportedLanguageModel
      // 2. Create a copy with changed languageCode, languageName, and isActive
      // 3. Verify the properties were changed
      // Expected Result: The specified properties should be changed, others unchanged

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const languageCode = 'en';
      const languageName = 'English';
      const isActive = true;

      // Act
      final original = SupportedLanguageModel(
        id: id,
        languageCode: languageCode,
        languageName: languageName,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final newUpdatedAt = DateTime(2025, 6, 19);
      final copy = original.copyWith(
        languageCode: 'fr',
        languageName: 'French',
        isActive: false,
        updatedAt: newUpdatedAt,
      );

      // Assert
      expect(copy.id, equals(original.id));
      expect(copy.languageCode, equals('fr'));
      expect(copy.languageName, equals('French'));
      expect(copy.isActive, equals(false));
      expect(copy.createdAt, equals(original.createdAt));
      expect(copy.updatedAt, equals(newUpdatedAt));
    });

    test('isActive toggling', () {
      // Description: Tests that isActive can be toggled using copyWith
      // Steps:
      // 1. Create a SupportedLanguageModel with isActive = true
      // 2. Create a copy with isActive = false
      // 3. Verify isActive was changed
      // Expected Result: isActive should be false in the copy

      // Arrange
      final id = Ulid();
      final updatedAt = DateTime.now();
      const languageCode = 'en';
      const languageName = 'English';

      // Act
      final original = SupportedLanguageModel(
        id: id,
        languageCode: languageCode,
        languageName: languageName,
        isActive: true,
        updatedAt: updatedAt,
      );
      final copy = original.copyWith(isActive: false);

      // Assert
      expect(copy.isActive, isFalse);
    });

    test('ID can be changed with copyWith', () {
      // Description: Tests that ID can be changed using copyWith
      // Steps:
      // 1. Create a SupportedLanguageModel
      // 2. Create a copy with a new ID
      // 3. Verify ID was changed
      // Expected Result: ID should be different in the copy

      // Arrange
      final id = Ulid();
      final newId = Ulid();
      final updatedAt = DateTime.now();
      const languageCode = 'en';
      const languageName = 'English';
      const isActive = true;

      // Act
      final original = SupportedLanguageModel(
        id: id,
        languageCode: languageCode,
        languageName: languageName,
        isActive: isActive,
        updatedAt: updatedAt,
      );
      final copy = original.copyWith(id: newId);

      // Assert
      expect(copy.id, equals(newId));
      expect(copy.id, isNot(equals(original.id)));
    });
  });
}
