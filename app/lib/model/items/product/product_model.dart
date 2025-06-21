import 'package:app/model/items/product/product_type.dart';
import 'package:ulid/ulid.dart';

/// Represents a product that can be purchased in the shop.
/// 
/// @property id Unique identifier for the product
/// @property productType The type of product (Physical, Digital, Other)
class ProductModel {
  final Ulid id;
  final ProductType productType;

  ProductModel({
    required this.id, 
    required this.productType});
}
