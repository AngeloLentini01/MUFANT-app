import 'package:app/data/generic/details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulid/ulid.dart';

void main() {
  group('DetailsModel', () {
    test('Constructor - Basic creation', () {
      // Description: Tests that a DetailsModel can be created with all required parameters
      // Steps:
      // 1. Create a DetailsModel with all required parameters
      // 2. Verify all properties match the provided values
      // Expected Result: All properties should match the provided values

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const name = 'Test Item';
      const description = 'This is a test item';
      const notes = 'Some additional notes';
      const imageUrlOrPath = 'https://example.com/image.jpg';

      // Act
      final model = DetailsModel(
        id: id,
        name: name,
        description: description,
        notes: notes,
        imageUrlOrPath: imageUrlOrPath,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Assert
      expect(model.id, equals(id));
      expect(model.name, equals(name));
      expect(model.description, equals(description));
      expect(model.notes, equals(notes));
      expect(model.imageUrlOrPath, equals(imageUrlOrPath));
      expect(model.createdAt, equals(createdAt));
      expect(model.updatedAt, equals(updatedAt));
    });

    test('Constructor - null imageUrlOrPath', () {
      // Description: Tests that a DetailsModel can be created with a null imageUrlOrPath
      // Steps:
      // 1. Create a DetailsModel with null imageUrlOrPath
      // 2. Verify imageUrlOrPath is null
      // Expected Result: imageUrlOrPath should be null

      // Arrange
      final id = Ulid();
      final updatedAt = DateTime.now();
      const name = 'Test Item';
      const description = 'This is a test item';
      const notes = 'Some additional notes';

      // Act
      final model = DetailsModel(
        id: id,
        name: name,
        description: description,
        notes: notes,
        imageUrlOrPath: null,
        updatedAt: updatedAt,
      );

      // Assert
      expect(model.imageUrlOrPath, isNull);
    });

    test('equality - identical objects', () {
      // Description: Tests that two DetailsModel instances with the same property values are considered equal
      // Steps:
      // 1. Create two DetailsModel instances with identical property values
      // 2. Compare them for equality
      // Expected Result: Models should be considered equal

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const name = 'Test Item';
      const description = 'This is a test item';
      const notes = 'Some additional notes';
      const imageUrlOrPath = 'https://example.com/image.jpg';

      // Act
      final model1 = DetailsModel(
        id: id,
        name: name,
        description: description,
        notes: notes,
        imageUrlOrPath: imageUrlOrPath,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final model2 = DetailsModel(
        id: id,
        name: name,
        description: description,
        notes: notes,
        imageUrlOrPath: imageUrlOrPath,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Assert
      expect(model1 == model2, isTrue);
    });

    test('equality - different values', () {
      // Description: Tests that two DetailsModel instances with different property values are not considered equal
      // Steps:
      // 1. Create two DetailsModel instances with different name values
      // 2. Compare them for equality
      // Expected Result: Models should not be considered equal

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const description = 'This is a test item';
      const notes = 'Some additional notes';
      const imageUrlOrPath = 'https://example.com/image.jpg';

      // Act
      final model1 = DetailsModel(
        id: id,
        name: 'Model 1',
        description: description,
        notes: notes,
        imageUrlOrPath: imageUrlOrPath,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final model2 = DetailsModel(
        id: id,
        name: 'Model 2',
        description: description,
        notes: notes,
        imageUrlOrPath: imageUrlOrPath,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Assert
      expect(model1 == model2, isFalse);
    });

    test('toString returns formatted string', () {
      // Description: Tests that toString returns a properly formatted string representation
      // Steps:
      // 1. Create a DetailsModel
      // 2. Call toString
      // 3. Verify result contains all property values
      // Expected Result: toString result should contain all property values

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const name = 'Test Item';
      const description = 'This is a test item';
      const notes = 'Some additional notes';
      const imageUrlOrPath = 'https://example.com/image.jpg';

      // Act
      final model = DetailsModel(
        id: id,
        name: name,
        description: description,
        notes: notes,
        imageUrlOrPath: imageUrlOrPath,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final toString = model.toString();

      // Assert
      expect(toString, contains(name));
      expect(toString, contains(description));
      expect(toString, contains(notes));
      expect(toString, contains(imageUrlOrPath));
      expect(toString, contains(createdAt.toString()));
      expect(toString, contains(updatedAt.toString()));
    });

    test('copyWith - change single property', () {
      // Description: Tests that copyWith creates a new instance with one changed property
      // Steps:
      // 1. Create a DetailsModel
      // 2. Create a copy with a changed name
      // 3. Verify only the name was changed
      // Expected Result: Only the name property should be different

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const name = 'Test Item';
      const description = 'This is a test item';
      const notes = 'Some additional notes';
      const imageUrlOrPath = 'https://example.com/image.jpg';

      // Act
      final original = DetailsModel(
        id: id,
        name: name,
        description: description,
        notes: notes,
        imageUrlOrPath: imageUrlOrPath,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final copy = original.copyWith(name: 'New Name');

      // Assert
      expect(copy.id, equals(original.id));
      expect(copy.name, equals('New Name'));
      expect(copy.description, equals(original.description));
      expect(copy.notes, equals(original.notes));
      expect(copy.imageUrlOrPath, equals(original.imageUrlOrPath));
      expect(copy.createdAt, equals(original.createdAt));
      expect(copy.updatedAt, equals(original.updatedAt));
    });

    test('copyWith - change multiple properties', () {
      // Description: Tests that copyWith creates a new instance with multiple changed properties
      // Steps:
      // 1. Create a DetailsModel
      // 2. Create a copy with changed name, description, and notes
      // 3. Verify the properties were changed
      // Expected Result: The specified properties should be changed, others unchanged

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);
      const name = 'Test Item';
      const description = 'This is a test item';
      const notes = 'Some additional notes';
      const imageUrlOrPath = 'https://example.com/image.jpg';

      // Act
      final original = DetailsModel(
        id: id,
        name: name,
        description: description,
        notes: notes,
        imageUrlOrPath: imageUrlOrPath,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final newUpdatedAt = DateTime(2025, 6, 19);
      final copy = original.copyWith(
        name: 'New Name',
        description: 'New Description',
        updatedAt: newUpdatedAt,
      );

      // Assert
      expect(copy.id, equals(original.id));
      expect(copy.name, equals('New Name'));
      expect(copy.description, equals('New Description'));
      expect(copy.notes, equals(original.notes));
      expect(copy.imageUrlOrPath, equals(original.imageUrlOrPath));
      expect(copy.createdAt, equals(original.createdAt));
      expect(copy.updatedAt, equals(newUpdatedAt));
    });

    test('copyWith - set imageUrlOrPath to null', () {
      // Description: Tests that copyWith can set imageUrlOrPath to null
      // Steps:
      // 1. Create a DetailsModel with non-null imageUrlOrPath
      // 2. Create a copy with null imageUrlOrPath
      // 3. Verify imageUrlOrPath is null
      // Expected Result: imageUrlOrPath should be null in the copy

      // Arrange
      final id = Ulid();
      final updatedAt = DateTime.now();
      const name = 'Test Item';
      const description = 'This is a test item';
      const notes = 'Some additional notes';

      // Act
      final original = DetailsModel(
        id: id,
        name: name,
        description: description,
        notes: notes,
        imageUrlOrPath: 'https://example.com/image.jpg',
        updatedAt: updatedAt,
      );
      final copy = original.copyWith(imageUrlOrPath: null);

      // Assert
      expect(copy.imageUrlOrPath, isNull);
    });
  });
}
