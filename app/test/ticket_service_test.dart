import 'package:flutter_test/flutter_test.dart';
import 'package:app/data/services/ticket_service.dart';
import 'package:app/model/items/ticket/ticket_display_data.dart';
import 'package:app/model/items/ticket/ticket_model.dart';
import 'package:app/model/museum/activity/museum_activity_model.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/museum/activity/type_of_museum_activity_model.dart';
import 'package:app/model/items/ticket/museum_activity_charging_rates.dart';
import 'package:flutter/material.dart';
import 'package:ulid/ulid.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('TicketService', () {
    late TicketService ticketService;

    setUp(() async {
      ticketService = TicketService();
      await ticketService.ready;
      await ticketService.refreshTickets(); // Clear tickets before each test
    });

    test('addTicket adds a ticket and getAllTickets returns it', () async {
      final details = DetailsModel(
        name: 'Test Event',
        description: 'Test Desc',
      );
      final museumActivity = MuseumActivityModel(
        id: Ulid(),
        location: 'Test Location',
        details: details,
        type: TypeOfMuseumActivityModel(
          id: Ulid(),
          details: DetailsModel(name: 'Exhibition'),
        ),
        activeTimePeriod: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 1)),
        ),
      );
      final ticketModel = TicketModel(
        id: Ulid(),
        details: details,
        price: TicketModel.ticketPrices[MuseumActivityChargingRates.full]!,
        quantity: 1,
        chargingRate: MuseumActivityChargingRates.full,
        museumActivity: museumActivity,
      );
      final ticket = TicketDisplayData(
        ticketModel: ticketModel,
        purchaseDate: DateTime.now(),
        isExpired: false,
      );

      await ticketService.addTicket(ticket);
      final tickets = ticketService.getAllTickets();
      expect(tickets, isNotEmpty);
      expect(tickets.first.ticketModel.details.name, 'Test Event');
    });
  });
}
