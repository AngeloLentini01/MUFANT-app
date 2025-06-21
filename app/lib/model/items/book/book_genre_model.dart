import 'package:app/model/generic/details_model.dart';
import 'package:flutter/material.dart';
import 'package:ulid/ulid.dart'; // Assuming you have a ULID package for Dart

/// Represents a book genre category with descriptive information and time period.
///
/// @property id Unique identifier for the book genre
/// @property details Descriptive information about the genre
/// @property timeRangeModel Time period associated with this genre (e.g., for promotions)
class BookGenreModel {
  final Ulid id;
  final DetailsModel details;
  final DateTimeRange timeRangeModel;

  BookGenreModel({
    required this.id,
    required this.details,
    required this.timeRangeModel,
  });
}
