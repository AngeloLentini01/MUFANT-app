import 'dart:typed_data';

import 'package:app/model/cart/cart_model.dart';
import 'package:app/model/generic/base_entity_model.dart';
import 'package:app/model/generic/details_model.dart';

/// Represents a user in the system with authentication information and related data.
/// Extends BaseEntityModel to include creation and update timestamps.
/// Includes custom equals and hashCode implementations for proper comparison.
///
/// @property username User's login name
/// @property email User's email address
/// @property passwordHash Hashed representation of the user's password for security
/// @property cart The user's current shopping cart
/// @property subscription The user's current subscription
/// @property createdAt When this user was created, defaults to current time
/// @property updatedAt When this user's information was last updated
class UserModel extends BaseEntityModel {
  final String username;
  final String email;
  final Uint8List passwordHash;
  final CartModel cart;
  late DetailsModel details;

  UserModel( {
    required super.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.cart,
    required this.details,
    required super.createdAt,
    required super.updatedAt,
  });
}
