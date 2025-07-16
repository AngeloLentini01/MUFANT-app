import 'package:app/model/cart/cart_item_model.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/museum/activity/museum_activity_model.dart';
import 'package:app/model/items/ticket/museum_activity_charging_rates.dart';
import 'package:money2/money2.dart';
import 'package:ulid/ulid.dart';

/// Represents a ticket that can be purchased for a museum activity.
/// Extends CartItemModel to inherit properties for cart items.
///
/// @property museumActivity The museum activity this ticket grants access to
class TicketModel extends CartItemModel {
  Map<String, dynamic> toJson() => {
    'id': id.toString(),
    'details': details.toJson(),
    'price': price.toString(),
    'quantity': quantity,
    'chargingRate': chargingRate.index,
    'museumActivity': museumActivity.toJson(),
  };

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
    id: Ulid.parse(json['id'] as String),
    details: DetailsModel.fromJson(json['details'] as Map<String, dynamic>),
    price: Money.parse(json['price'] as String, isoCode: 'EUR'),
    quantity: json['quantity'] as int,
    chargingRate:
        MuseumActivityChargingRates.values[json['chargingRate'] as int],
    museumActivity: MuseumActivityModel.fromJson(
      json['museumActivity'] as Map<String, dynamic>,
    ),
  );
  final MuseumActivityModel museumActivity;
  final MuseumActivityChargingRates chargingRate;
  TicketModel({
    required super.id,
    required super.details,
    required super.price,
    required super.quantity,
    required this.chargingRate,
    required this.museumActivity,
  });

  static final Map<MuseumActivityChargingRates, Money> ticketPrices = {
    MuseumActivityChargingRates.full: Money.fromInt(
      8,
      isoCode: 'EUR',
    ), // Full price
    MuseumActivityChargingRates.uniStudentsOver65AndTurinAIACEAssociates:
        Money.fromInt(7, isoCode: 'EUR'),
    MuseumActivityChargingRates.disabledAndTurinPiedmontCard: Money.fromInt(
      6,
      isoCode: 'EUR',
    ),
    MuseumActivityChargingRates.kidsBetween4And10: Money.fromInt(
      5,
      isoCode: 'EUR',
    ),
    MuseumActivityChargingRates.disabledPersonAccompanier: Money.fromInt(
      0,
      isoCode: 'EUR',
    ),
    MuseumActivityChargingRates.under4: Money.fromInt(0, isoCode: 'EUR'),
    MuseumActivityChargingRates.hasPiedmontAndValledAostaMuseumPass:
        Money.fromInt(0, isoCode: 'EUR'),
  };
  static TicketModel guidelessEntryfull({
    required MuseumActivityModel museumActivity,
    required int quantity,
  }) {
    return TicketModel(
      id: museumActivity.id,
      details: museumActivity.details,
      price: ticketPrices[MuseumActivityChargingRates.full]!,
      quantity: quantity,
      chargingRate: MuseumActivityChargingRates.full,
      museumActivity: museumActivity,
    );
  }

  static TicketModel guidelessUniStudentsOver65AndTurinAiaceAssociates({
    required MuseumActivityModel museumActivity,
    required int quantity,
  }) {
    return TicketModel(
      id: museumActivity.id,
      details: museumActivity.details,
      price:
          ticketPrices[MuseumActivityChargingRates
              .uniStudentsOver65AndTurinAIACEAssociates]!,
      quantity: quantity,
      chargingRate:
          MuseumActivityChargingRates.uniStudentsOver65AndTurinAIACEAssociates,
      museumActivity: museumActivity,
    );
  }

  static TicketModel guidelessDisabledAndTurinPiedmontCard({
    required MuseumActivityModel museumActivity,
    required int quantity,
  }) {
    return TicketModel(
      id: museumActivity.id,
      details: museumActivity.details,
      price:
          ticketPrices[MuseumActivityChargingRates
              .disabledAndTurinPiedmontCard]!,
      quantity: quantity,
      chargingRate: MuseumActivityChargingRates.disabledAndTurinPiedmontCard,
      museumActivity: museumActivity,
    );
  }

  static TicketModel guidelessKidsBetween4And10({
    required MuseumActivityModel museumActivity,
    required int quantity,
  }) {
    return TicketModel(
      id: museumActivity.id,
      details: museumActivity.details,
      price: ticketPrices[MuseumActivityChargingRates.kidsBetween4And10]!,
      quantity: quantity,
      chargingRate: MuseumActivityChargingRates.kidsBetween4And10,
      museumActivity: museumActivity,
    );
  }

  static TicketModel guidelessDisabledPersonAccompanier({
    required MuseumActivityModel museumActivity,
    required int quantity,
  }) {
    return TicketModel(
      id: museumActivity.id,
      details: museumActivity.details,
      price:
          ticketPrices[MuseumActivityChargingRates.disabledPersonAccompanier]!,
      quantity: quantity,
      chargingRate: MuseumActivityChargingRates.disabledPersonAccompanier,
      museumActivity: museumActivity,
    );
  }

  static TicketModel freeUnder4({
    required MuseumActivityModel museumActivity,
    required int quantity,
  }) {
    return TicketModel(
      id: museumActivity.id,
      details: museumActivity.details,
      price: ticketPrices[MuseumActivityChargingRates.under4]!,
      quantity: quantity,
      chargingRate: MuseumActivityChargingRates.under4,
      museumActivity: museumActivity,
    );
  }

  static TicketModel guidelessHasPiedmontAndValledAostaMuseumPass({
    required MuseumActivityModel museumActivity,
    required int quantity,
  }) {
    return TicketModel(
      id: museumActivity.id,
      details: museumActivity.details,
      price:
          ticketPrices[MuseumActivityChargingRates
              .hasPiedmontAndValledAostaMuseumPass]!,
      quantity: quantity,
      chargingRate:
          MuseumActivityChargingRates.hasPiedmontAndValledAostaMuseumPass,
      museumActivity: museumActivity,
    );
  }
}
