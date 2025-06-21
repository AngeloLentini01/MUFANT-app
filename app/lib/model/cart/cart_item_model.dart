import 'package:app/model/generic/details_model.dart';
import 'package:money2/money2.dart';
import 'package:ulid/ulid.dart';

/// Base class for all items that can be added to a shopping cart.
/// Provides common properties for cart items such as price, quantity, and type.
///
/// @property id Unique identifier for the cart item
/// @property details Descriptive information about the item
/// @property price The price of a single unit of this item
/// @property quantity The number of units of this item in the cart
/// @property cartItemType The category of item (PRODUCT, BOOK, TICKET, etc.)
abstract class CartItemModel {
  final Ulid id;
  final DetailsModel details;
  final Money price;
  final int quantity;

  // Constructor with optional cartItemType parameter
  CartItemModel({
    required this.id,
    required this.details,
    required this.price,
    required this.quantity,
  });
}
