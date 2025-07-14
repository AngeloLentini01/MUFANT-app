class Payment {
  final int? id;
  final int cartId;
  final double amount;
  final String paymentMethod;
  final String transactionId;
  final String status; // 'pending', 'success', 'failed'
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    this.id,
    required this.cartId,
    required this.amount,
    required this.paymentMethod,
    required this.transactionId,
    this.status = 'pending',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Factory constructor to create a Payment object from a map
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      cartId: map['cart_id'],
      amount: map['amount'],
      paymentMethod: map['payment_method'],
      transactionId: map['transaction_id'],
      status: map['status'] ?? 'pending',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,
    );
  }

  // Convert a Payment object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cart_id': cartId,
      'amount': amount,
      'payment_method': paymentMethod,
      'transaction_id': transactionId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of this Payment with the given fields updated
  Payment copyWith({
    int? id,
    int? cartId,
    double? amount,
    String? paymentMethod,
    String? transactionId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
