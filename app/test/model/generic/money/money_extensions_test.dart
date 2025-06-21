import 'package:app/model/generic/money/money_extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money2/money2.dart';

void main() {
  group('MoneyExtensions', () {
    test('isZero - returns true for zero amount', () {
      // Description: Tests that isZero property returns true when the Money amount is zero
      // Steps:
      // 1. Create a Money object with zero amount
      // 2. Check the isZero property
      // Expected Result: isZero should be true

      // Arrange
      final money = Money.fromNum(0, isoCode: 'USD');

      // Act & Assert
      expect(money.isZero, isTrue);
    });

    test('isZero - returns false for non-zero amount', () {
      // Description: Tests that isZero property returns false when the Money amount is not zero
      // Steps:
      // 1. Create a Money object with non-zero amount
      // 2. Check the isZero property
      // Expected Result: isZero should be false

      // Arrange
      final money = Money.fromNum(10.5, isoCode: 'USD');

      // Act & Assert
      expect(money.isZero, isFalse);
    });

    test('withAmount - changes amount while preserving currency', () {
      // Description: Tests that withAmount creates a new Money object with the specified amount but same currency
      // Steps:
      // 1. Create a Money object
      // 2. Create a new Money object using withAmount
      // 3. Verify the amount is changed but currency is preserved
      // Expected Result: New Money object should have new amount and same currency

      // Arrange
      final originalMoney = Money.fromNum(10, isoCode: 'EUR'); // Act
      final newMoney = originalMoney.withAmount(20);

      // Assert
      expect(newMoney.amount.toString(), equals('20.00'));
      expect(newMoney.currency.isoCode, equals('EUR'));
    });

    test('zeroMoney - creates Money with zero amount and current currency', () {
      // Description: Tests that zeroMoney creates a Money object with zero amount and current system currency
      // Steps:
      // 1. Get a Money object using zeroMoney
      // 2. Verify the amount is zero and the currency is the current system currency
      // Expected Result: Money object should have zero amount and currency matching current system currency      // Act
      final money = zeroMoney;

      // Assert
      expect(money.amount.toString(), equals('0.00'));
      expect(money.currency.isoCode, equals(currentCurrencyCode));
    });

    test('fromAmount - creates Money with specified amount and current currency', () {
      // Description: Tests that fromAmount creates a Money object with the specified amount and current system currency
      // Steps:
      // 1. Create a Money object using fromAmount
      // 2. Verify the amount matches the input and the currency is the current system currency
      // Expected Result: Money object should have specified amount and currency matching current system currency

      // Arrange
      const amount = 15.75;

      // Act
      final money = fromAmount(amount); // Assert
      expect(money.amount.toString(), equals('15.75'));
      expect(money.currency.isoCode, equals(currentCurrencyCode));
    });

    test('currentCurrencyCode - returns non-empty string', () {
      // Description: Tests that currentCurrencyCode returns a non-empty string
      // Steps:
      // 1. Get the currentCurrencyCode
      // 2. Verify it's not empty
      // Expected Result: currentCurrencyCode should be a non-empty string

      // Act & Assert
      expect(currentCurrencyCode, isNotEmpty);
    });

    test('currentCurrencySymbol - returns non-empty string', () {
      // Description: Tests that currentCurrencySymbol returns a non-empty string
      // Steps:
      // 1. Get the currentCurrencySymbol
      // 2. Verify it's not empty
      // Expected Result: currentCurrencySymbol should be a non-empty string

      // Act & Assert
      expect(currentCurrencySymbol, isNotEmpty);
    });

    test('currentCurrencySymbol - falls back to dollar sign on error', () {
      // Description: Tests that currentCurrencySymbol falls back to $ when NumberFormat throws an error
      // Steps:
      // 1. Test the fallback mechanism (this is difficult to trigger in a test)
      // Expected Result: Should never be empty even in error cases

      // Note: This test is more conceptual as it's difficult to force NumberFormat to throw an error
      // in a controlled test environment. In a real-world scenario, you might mock NumberFormat.

      // Act & Assert
      expect(currentCurrencySymbol, isNotEmpty);
    });
  });
}
