import 'package:app/data/cart/cart_item_model.dart';
import 'package:app/data/museum/museumActivity/museum_activity_model.dart';
import 'package:app/data/items/ticket/ticket_charging_rates.dart';

/// Represents a ticket that can be purchased for a museum activity.
/// Extends CartItemModel to inherit properties for cart items.
///
/// @property museumActivity The museum activity this ticket grants access to
class TicketModel extends CartItemModel {
  final MuseumActivityModel museumActivity;
  final TicketChargingRates chargingRate;
  TicketModel({
    required super.id,
    required super.details,
    required super.price,
    required super.quantity,
    required this.chargingRate,
    required this.museumActivity,
  });
}
