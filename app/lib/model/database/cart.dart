class Cart {
  final String? id;
  final String userFk;
  final String? couponFk;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    this.id,
    required this.userFk,
    this.couponFk,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Factory constructor to create a Cart object from a map
  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'],
      userFk: map['user_fk'],
      couponFk: map['coupon_fk'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['last_update_at'] != null
          ? DateTime.parse(map['last_update_at'])
          : null,
    );
  }

  // Convert a Cart object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_fk': userFk,
      'coupon_fk': couponFk,
      'created_at': createdAt.toIso8601String(),
      'last_update_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of this Cart with the given fields updated
  Cart copyWith({
    String? id,
    String? userFk,
    String? couponFk,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      id: id ?? this.id,
      userFk: userFk ?? this.userFk,
      couponFk: couponFk ?? this.couponFk,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
