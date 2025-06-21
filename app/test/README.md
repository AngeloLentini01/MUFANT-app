# Testing Framework for MUFANT App

This project uses Flutter's built-in testing framework along with additional packages to provide a comprehensive testing solution.

## Testing Packages

- **flutter_test**: Flutter's built-in testing framework for widget and unit tests
- **mockito**: For mocking dependencies in unit tests
- **faker**: For generating test data
- **test**: Additional testing utilities

## Test Structure

Tests are organized to mirror the project structure:

```txt
test/
  ├── data/
  │   ├── generic/
  │   │   ├── base_entity_model_test.dart
  │   │   ├── details_model_test.dart
  │   │   ├── supported_language_model_test.dart
  │   │   └── money/
  │   │       └── money_extensions_test.dart
  │   ├── cart/
  │   ├── items/
  │   └── museum/
  └── widget_test.dart
```

## Running Tests

### Running All Tests

```bash
flutter test
```

### Running Specific Tests

```bash
flutter test test/data/generic/base_entity_model_test.dart
```

### Running Tests with Coverage

```bash
flutter test --coverage
```

To view the coverage report, install the `lcov` tool and run:

```bash
genhtml coverage/lcov.info -o coverage/html
```

Then open `coverage/html/index.html` in a browser.

## Test Case Format

Each test follows this format:

1. **Name**: Clear, descriptive name of what's being tested
2. **Description**: Explains what the test verifies
3. **Steps**: Outlines the steps the test takes
4. **Expected Result**: Describes what should happen

Example:

```dart
test('Constructor - Basic creation', () {
  // Description: Tests that a Model can be created with all required parameters
  // Steps:
  // 1. Create a Model with all required parameters
  // 2. Verify all properties match the provided values
  // Expected Result: All properties should match the provided values

  // Arrange
  // ...
  
  // Act
  // ...
  
  // Assert
  // ...
});
```

## Best Practices

1. **Arrange-Act-Assert (AAA)**: Structure tests with clear Arrange, Act, and Assert sections
2. **Test Independence**: Each test should be independent and not rely on other tests
3. **Mock Dependencies**: Use mockito to mock external dependencies
4. **Test Edge Cases**: Include tests for edge cases, not just the happy path
5. **Keep Tests Fast**: Tests should run quickly to encourage frequent testing

## Adding New Tests

1. Create a new test file in the appropriate directory
2. Follow the existing test patterns
3. Ensure each test covers a specific aspect of the class
4. Include both typical use cases and edge cases
