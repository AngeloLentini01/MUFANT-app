import 'package:intl/intl.dart';
import 'package:money2/money2.dart';

/// Extension for instance methods on Money objects
extension MoneyExtensions on Money {
  bool get isZero => amount == Fixed.zero;

  Money withAmount(num newAmount) =>
      Money.fromNum(newAmount, isoCode: currency.isoCode);
}

/// Get the current currency code based on system locale
String get currentCurrencyCode =>
    NumberFormat.simpleCurrency().currencyName ?? 'USD';

/// Get the current currency symbol based on system locale
String get currentCurrencySymbol {
  try {
    return NumberFormat.simpleCurrency().currencySymbol;
  } catch (e) {
    return '\$';
  }
}

/// Get a Money object with zero amount in the current system currency
Money get zeroMoney => Money.fromNum(0, isoCode: currentCurrencyCode);

/// Create a Money object with the specified amount in the current system currency
Money fromAmount(num amount) =>
    Money.fromNum(amount, isoCode: currentCurrencyCode);
