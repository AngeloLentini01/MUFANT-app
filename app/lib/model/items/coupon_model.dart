import 'dart:typed_data';

import 'package:app/model/generic/details_model.dart';
import 'package:ulid/ulid.dart';
import 'package:flutter/material.dart';

/// Represents a discount coupon that can be applied to a cart.
/// Includes custom equals and hashCode implementations for proper comparison.
///
/// @property id Unique identifier for the coupon
/// @property codeHash Hashed representation of the coupon code for security
/// @property usages Number of times this coupon can be used
/// @property discountPercentage Percentage discount provided by this coupon
/// @property validityTimePeriod Time period during which this coupon is valid
/// @property details Descriptive information about the coupon
class CouponModel {
  final Ulid id;
  final Uint8List codeHash;
  final int usages;
  final int discountPercentage;
  final DateTimeRange validityTimePeriod;
  final DetailsModel details;

  CouponModel({
    required this.id,
    required this.codeHash,
    required this.usages,
    required this.discountPercentage,
    required this.validityTimePeriod,
    required this.details,
  });
}
