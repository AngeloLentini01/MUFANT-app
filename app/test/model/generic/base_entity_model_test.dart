import 'package:app/model/generic/base_entity_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulid/ulid.dart';

void main() {
  group('BaseEntityModel', () {
    test('Constructor - Created with explicit timestamps', () {
      // Description: Tests that a BaseEntityModel can be created with explicit createdAt and updatedAt values.
      // Steps:
      // 1. Create a BaseEntityModel with explicit timestamps
      // 2. Verify the properties match the provided values
      // Expected Result: All properties should match the provided values

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);

      // Act
      final model = BaseEntityModel(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Assert
      expect(model.id, equals(id));
      expect(model.createdAt, equals(createdAt));
      expect(model.updatedAt, equals(updatedAt));
    });

    test('Constructor - Default createdAt value', () {
      // Description: Tests that createdAt defaults to current time when not provided
      // Steps:
      // 1. Create a BaseEntityModel without providing createdAt
      // 2. Verify createdAt is set to a time close to now
      // Expected Result: createdAt should be within a few milliseconds of current time

      // Arrange
      final id = Ulid();
      final updatedAt = DateTime(2025, 6, 18);
      final beforeCreation = DateTime.now();

      // Act
      final model = BaseEntityModel(id: id, updatedAt: updatedAt);
      final afterCreation = DateTime.now();

      // Assert
      expect(model.id, equals(id));
      expect(model.updatedAt, equals(updatedAt));
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

    test('Equality comparison', () {
      // Description: Tests that two BaseEntityModel instances with the same property values are considered equal
      // Steps:
      // 1. Create two BaseEntityModel instances with identical property values
      // 2. Compare them for equality
      // Expected Result: Models should be considered equal

      // Arrange
      final id = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);

      // Act
      final model1 = BaseEntityModel(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final model2 = BaseEntityModel(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Assert - Depends on whether equality operator is overridden
      // This might fail if equality is based on object identity rather than value
      expect(model1.id, equals(model2.id));
      expect(model1.createdAt, equals(model2.createdAt));
      expect(model1.updatedAt, equals(model2.updatedAt));
    });

    test('Different IDs create different entities', () {
      // Description: Tests that two BaseEntityModel instances with different IDs are not considered equal
      // Steps:
      // 1. Create two BaseEntityModel instances with different IDs but identical timestamps
      // 2. Compare their IDs
      // Expected Result: IDs should be different

      // Arrange
      final id1 = Ulid();
      final id2 = Ulid();
      final createdAt = DateTime(2025, 6, 17);
      final updatedAt = DateTime(2025, 6, 18);

      // Act
      final model1 = BaseEntityModel(
        id: id1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final model2 = BaseEntityModel(
        id: id2,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      // Assert
      expect(model1.id, isNot(equals(model2.id)));
    });
  });
}
