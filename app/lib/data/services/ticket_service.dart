import 'package:app/model/items/ticket/ticket_model.dart';
import 'package:app/model/items/ticket/ticket_display_data.dart';
import 'package:app/model/museum/activity/museum_activity_model.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/museum/activity/type_of_museum_activity_model.dart';
import 'package:app/model/items/ticket/museum_activity_charging_rates.dart';
import 'package:ulid/ulid.dart';
import 'package:flutter/material.dart';

/// Service class to manage tickets data
/// This ensures consistency between profile page and ticket list page
class TicketService {
  static final TicketService _instance = TicketService._internal();
  factory TicketService() => _instance;
  TicketService._internal();

  List<TicketDisplayData> _tickets = [];

  /// Get all tickets sorted properly (active first, then expired)
  List<TicketDisplayData> getAllTickets() {
    if (_tickets.isEmpty) {
      _loadTickets();
    }
    return List.from(_tickets);
  }

  /// Get the most recent ticket (first in the sorted list)
  /// This is the ticket that should appear on the profile page
  TicketDisplayData? getLatestTicket() {
    final tickets = getAllTickets();
    return tickets.isNotEmpty ? tickets.first : null;
  }

  /// Load tickets - this simulates API call
  /// TODO: Replace with real API integration
  void _loadTickets() {
    final mockTickets = <TicketDisplayData>[
      // Active tickets
      _createMockTicket(
        name: '30 ANNI DI SAILOR',
        description: 'Celebrazione dei 30 anni di Sailor Moon con mostre esclusive e memorabilia',
        location: 'piazza Riccardo Valle 5, Torino',
        startDate: DateTime(2025, 5, 29, 15, 30),
        endDate: DateTime(2025, 5, 29, 19, 0),
        purchaseDate: DateTime(2025, 5, 15),
        chargingRate: MuseumActivityChargingRates.full,
      ),
      _createMockTicket(
        name: 'MOSTRA ARTE MODERNA',
        description: 'Esposizione di arte contemporanea con opere di artisti internazionali',
        location: 'Via Roma 123, Milano',
        startDate: DateTime(2025, 7, 15, 10, 0),
        endDate: DateTime(2025, 7, 15, 18, 0),
        purchaseDate: DateTime(2025, 7, 1),
        chargingRate: MuseumActivityChargingRates.uniStudentsOver65AndTurinAIACEAssociates,
      ),

      // Expired tickets
      _createMockTicket(
        name: 'LEONARDO DA VINCI',
        description: 'Retrospettiva dedicata al genio rinascimentale con opere e invenzioni',
        location: 'Castello Sforzesco, Milano',
        startDate: DateTime(2025, 3, 10, 14, 0),
        endDate: DateTime(2025, 3, 10, 17, 0),
        purchaseDate: DateTime(2025, 2, 20),
        chargingRate: MuseumActivityChargingRates.kidsBetween4And10,
        isExpired: true,
      ),
      _createMockTicket(
        name: 'STORIA ANTICA',
        description: 'Viaggio attraverso le antiche civiltà con reperti archeologici',
        location: 'Museo Egizio, Torino',
        startDate: DateTime(2025, 1, 5, 9, 0),
        endDate: DateTime(2025, 1, 5, 13, 0),
        purchaseDate: DateTime(2024, 12, 15),
        chargingRate: MuseumActivityChargingRates.full,
        isExpired: true,
      ),
    ];

    _tickets = mockTickets;

    // Sort tickets: non-expired first (by event date desc), then expired (by event date desc)
    _tickets.sort((a, b) {
      if (a.isExpired != b.isExpired) {
        return a.isExpired ? 1 : -1; // Non-expired first
      }
      return b.eventDateTime.compareTo(a.eventDateTime); // Most recent first within each group
    });
  }

  /// Refresh tickets (simulates API refresh)
  Future<void> refreshTickets() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    _tickets.clear();
    _loadTickets();
  }

  /// Helper method to create mock tickets with proper model structure
  TicketDisplayData _createMockTicket({
    required String name,
    required String description,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime purchaseDate,
    required MuseumActivityChargingRates chargingRate,
    bool isExpired = false,
  }) {
    final details = DetailsModel(name: name, description: description);

    final museumActivity = MuseumActivityModel(
      id: Ulid(),
      location: location,
      details: details,
      type: TypeOfMuseumActivityModel(
        id: Ulid(),
        details: DetailsModel(name: 'Exhibition'),
      ),
      activeTimePeriod: DateTimeRange(start: startDate, end: endDate),
    );

    final ticketModel = TicketModel(
      id: Ulid(),
      details: details,
      price: TicketModel.ticketPrices[chargingRate]!,
      quantity: 1,
      chargingRate: chargingRate,
      museumActivity: museumActivity,
    );

    return TicketDisplayData(
      ticketModel: ticketModel,
      purchaseDate: purchaseDate,
      isExpired: isExpired || DateTime.now().isAfter(endDate),
    );
  }
}
