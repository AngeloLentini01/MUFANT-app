class CartItem {
  final int? id;
  final int cartId;
  final int itemId;
  final String itemType; // 'ticket', 'product', 'book', etc.
  final double price;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartItem({
    this.id,
    required this.cartId,
    required this.itemId,
    required this.itemType,
    required this.price,
    this.quantity = 1,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Factory constructor to create a CartItem object from a map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      cartId: map['cart_id'],
      itemId: map['item_id'],
      itemType: map['item_type'],
      price: map['price'],
      quantity: map['quantity'] ?? 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  // Convert a CartItem object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cart_id': cartId,
      'item_id': itemId,
      'item_type': itemType,
      'price': price,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of this CartItem with the given fields updated
  CartItem copyWith({
    int? id,
    int? cartId,
    int? itemId,
    String? itemType,
    double? price,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      itemId: itemId ?? this.itemId,
      itemType: itemType ?? this.itemType,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
