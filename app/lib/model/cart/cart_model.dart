import 'package:app/model/cart/cart_item_model.dart';
import 'package:app/model/generic/base_entity_model.dart';
import 'package:app/model/generic/money/money_extensions.dart';
import 'package:money2/money2.dart';
import '../items/coupon_model.dart';

/// Represents a shopping cart containing items and an optional discount coupon.
/// Extends BaseEntityModel to include creation and update timestamps.
///
/// @property coupon Optional coupon applied to the cart for discounts
/// @property cartItems List of items in the cart
/// @property totalPrice Calculated property that returns the total price of all items,
///                     with any applicable coupon discount applied
/// @property createdAt When this cart was created, defaults to current time
/// @property updatedAt When this cart was last updated
class CartModel extends BaseEntityModel {
  final CouponModel? coupon;
  final List<CartItemModel> cartItems;

  CartModel({
    required super.id,
    this.coupon,
    required this.cartItems,
    super.createdAt,
    required super.updatedAt,
  });

  /// Calculates the total price of all items in the cart, with any applicable coupon discount
  Money get totalPrice {
    // Calculate the sum of all item prices multiplied by their quantities
    double itemsTotal = 0;
    for (var item in cartItems) {
      // Convert Money amount to double for calculation
      double itemPrice = double.parse(item.price.amount.toString());
      itemsTotal += itemPrice * item.quantity;
    }

    // Apply discount if coupon is present
    final discountFactor =
        coupon != null ? 1 - (coupon!.discountPercentage / 100) : 1.0;
    final finalAmount = itemsTotal * discountFactor;

    // Create and return the Money object with the currency code string
    return Money.fromNum(
      finalAmount,
      isoCode: currentCurrencyCode,
    );
  }
}
