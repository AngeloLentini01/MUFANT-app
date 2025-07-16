// ignore_for_file: unused_element

import 'package:app/model/items/ticket/ticket_model.dart';
import 'package:app/model/items/ticket/ticket_display_data.dart';
import 'package:app/model/museum/activity/museum_activity_model.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/museum/activity/type_of_museum_activity_model.dart';
import 'package:app/model/items/ticket/museum_activity_charging_rates.dart';
import 'package:ulid/ulid.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class to manage tickets data
/// This ensures consistency between profile page and ticket list page
class TicketService {
  static const String _storageKey = 'user_tickets';

  /// Add a new ticket to the user's tickets
  Future<void> addTicket(TicketDisplayData ticket) async {
    _tickets.insert(0, ticket);
    _sortTickets();
    await _saveTickets();
  }

  static final TicketService _instance = TicketService._internal();
  factory TicketService() => _instance;
  late final Future<void> ready;
  TicketService._internal() {
    ready = _loadTickets();
  }

  final List<TicketDisplayData> _tickets = [];

  /// Get all tickets sorted properly (active first, then expired)
  List<TicketDisplayData> getAllTickets() {
    return List.from(_tickets);
  }

  /// Get the most recent ticket (first in the sorted list)
  /// This is the ticket that should appear on the profile page
  TicketDisplayData? getLatestTicket() {
    final tickets = getAllTickets();
    return tickets.isNotEmpty ? tickets.first : null;
  }

  // Removed _loadTickets and all mock/demo ticket logic.

  /// Refresh tickets (reloads from storage)
  Future<void> refreshTickets() async {
    // Reload tickets from storage instead of clearing them
    await Future.delayed(const Duration(seconds: 1));
    await _loadTickets();
  }

  void _sortTickets() {
    _tickets.sort((a, b) {
      if (a.isExpired != b.isExpired) {
        return a.isExpired ? 1 : -1;
      }
      return b.eventDateTime.compareTo(a.eventDateTime);
    });
  }

  Future<void> _saveTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final ticketJsonList = _tickets.map((t) => t.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(ticketJsonList));
  }

  Future<void> _loadTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _tickets.clear();
      _tickets.addAll(jsonList.map((e) => TicketDisplayData.fromJson(e)));
      _sortTickets();
    }
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
