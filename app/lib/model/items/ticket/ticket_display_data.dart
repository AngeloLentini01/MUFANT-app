import 'package:app/model/items/ticket/ticket_model.dart';
import 'package:app/model/items/ticket/museum_activity_charging_rates.dart';
import 'package:intl/intl.dart';

/// Enhanced ticket data model that wraps TicketModel with UI-specific properties
///
/// This class provides a convenient interface for displaying ticket information
/// in the UI while maintaining separation from the core business logic.
class TicketDisplayData {
  final TicketModel ticketModel;
  final DateTime purchaseDate;
  final bool isExpired;

  TicketDisplayData({
    required this.ticketModel,
    required this.purchaseDate,
    required this.isExpired,
  });

  Map<String, dynamic> toJson() => {
    'ticketModel': ticketModel.toJson(),
    'purchaseDate': purchaseDate.toIso8601String(),
    'isExpired': isExpired,
  };

  factory TicketDisplayData.fromJson(Map<String, dynamic> json) =>
      TicketDisplayData(
        ticketModel: TicketModel.fromJson(
          json['ticketModel'] as Map<String, dynamic>,
        ),
        purchaseDate: DateTime.parse(json['purchaseDate'] as String),
        isExpired: json['isExpired'] as bool,
      );

  // Convenience getters for UI display
  String get eventTitle => ticketModel.museumActivity.details.name;
  String get eventDescription =>
      ticketModel.museumActivity.details.description ?? '';
  String get venueAddress => ticketModel.museumActivity.location;
  String get eventDate => DateFormat(
    'dd, MMMM yyyy',
  ).format(ticketModel.museumActivity.activeTimePeriod.start);
  String get eventTime =>
      '${DateFormat('HH:mm').format(ticketModel.museumActivity.activeTimePeriod.start)} - ${DateFormat('HH:mm').format(ticketModel.museumActivity.activeTimePeriod.end)}';
  String get ticketPrice => ticketModel.price.toString();
  String get chargingRateType =>
      _getChargingRateDisplayName(ticketModel.chargingRate);
  DateTime get eventDateTime =>
      ticketModel.museumActivity.activeTimePeriod.start;

  /// Get a user-friendly display name for the charging rate
  String _getChargingRateDisplayName(MuseumActivityChargingRates rate) {
    switch (rate) {
      case MuseumActivityChargingRates.full:
        return 'Full Price';
      case MuseumActivityChargingRates.uniStudentsOver65AndTurinAIACEAssociates:
        return 'Student/Senior';
      case MuseumActivityChargingRates.disabledAndTurinPiedmontCard:
        return 'Disabled/Card';
      case MuseumActivityChargingRates.kidsBetween4And10:
        return 'Child (4-10)';
      case MuseumActivityChargingRates.disabledPersonAccompanier:
        return 'Companion';
      case MuseumActivityChargingRates.under4:
        return 'Free (Under 4)';
      case MuseumActivityChargingRates.hasPiedmontAndValledAostaMuseumPass:
        return 'Museum Pass';
    }
  }
}
