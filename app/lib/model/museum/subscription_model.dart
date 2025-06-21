import 'package:app/model/generic/details_model.dart';
import 'package:flutter/material.dart';
import 'package:ulid/ulid.dart';

/// Represents a user subscription plan with details and validity period.
///
/// @property details Descriptive information about the subscription
/// @property validityTimePeriod Time period during which this subscription is valid
class SubscriptionModel {
  final Ulid id;
  final DetailsModel details;
  final DateTimeRange validityTimePeriod;

  bool get isActive =>
      validityTimePeriod.start.isBefore(DateTime.now()) &&
      validityTimePeriod.end.isAfter(DateTime.now());

  const SubscriptionModel({
    required this.id,
    required this.details,
    required this.validityTimePeriod,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionModel &&
          runtimeType == other.runtimeType &&
          details == other.details &&
          validityTimePeriod == other.validityTimePeriod;

  @override
  int get hashCode => details.hashCode ^ validityTimePeriod.hashCode;

  @override
  String toString() =>
      'SubscriptionModel(details: $details, validityTimePeriod: $validityTimePeriod)';

  SubscriptionModel copyWith({
    DetailsModel? details,
    DateTimeRange? validityTimePeriod,
  }) {
    return SubscriptionModel(
      id: id,
      details: details ?? this.details,
      validityTimePeriod: validityTimePeriod ?? this.validityTimePeriod,
    );
  }
}
