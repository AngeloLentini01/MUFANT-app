import 'package:app/data/generic/base_entity_model.dart';
import 'package:app/data/generic/money/money_extensions.dart';
import 'package:flutter/material.dart';
import 'payment_status.dart';

/// Represents a payment transaction in the system.
/// Extends BaseEntityModel to include creation and update timestamps.
///
/// @property paymentMethod The method used for payment (credit card, PayPal, etc.)
/// @property amount The monetary value of the payment
/// @property transactionId External identifier for the payment transaction
/// @property status Current status of the payment (PENDING, SUCCESS, FAILED)
/// @property activeTimePeriod Time period associated with this payment
/// @property currencyCode The currency in which the payment was made
/// @property createdAt When this payment was created, defaults to current time
/// @property updatedAt When this payment was last updated
class PaymentModel extends BaseEntityModel {
  final String paymentMethod;
  final double amount;
  final String transactionId;
  final PaymentStatus status;
  final DateTimeRange activeTimePeriod;
  final String currencyCode;

  PaymentModel({
    required super.id,
    required this.paymentMethod,
    required this.amount,
    required this.transactionId,
    required this.status,
    required this.activeTimePeriod,
    String? currencyCode,
    super.createdAt,
    required super.updatedAt,
  }) : currencyCode = currencyCode ?? currentCurrencyCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModel &&
          runtimeType == other.runtimeType &&
          paymentMethod == other.paymentMethod &&
          amount == other.amount &&
          transactionId == other.transactionId &&
          status == other.status &&
          activeTimePeriod == other.activeTimePeriod &&
          currencyCode == other.currencyCode &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      paymentMethod.hashCode ^
      amount.hashCode ^
      transactionId.hashCode ^
      status.hashCode ^
      activeTimePeriod.hashCode ^
      currencyCode.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'PaymentModel(paymentMethod: $paymentMethod, amount: $amount, '
      'transactionId: $transactionId, status: $status, '
      'activeTimePeriod: $activeTimePeriod, currencyCode: $currencyCode, '
      'createdAt: $createdAt, updatedAt: $updatedAt)';
}
