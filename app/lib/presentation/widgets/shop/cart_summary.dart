import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final double totalAmount;
  final int totalItems;
  final VoidCallback? onClearCart;
  final VoidCallback? onCheckout;
  final String checkoutText;
  final bool showClearButton;
  final bool showCheckoutButton;

  const CartSummary({
    super.key,
    required this.totalAmount,
    required this.totalItems,
    this.onClearCart,
    this.onCheckout,
    this.showClearButton = true,
    this.showCheckoutButton = true,
    this.checkoutText = 'Checkout',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          top: BorderSide(color: kPinkColor.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total to pay',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  Text(
                    '€${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$totalItems item${totalItems > 1 ? 's' : ''}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  // Clear cart button
                  if (showClearButton && onClearCart != null) ...[
                    ElevatedButton(
                      onPressed: onClearCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  // Checkout button
                  if (showCheckoutButton && onCheckout != null)
                    ElevatedButton(
                      onPressed: onCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPinkColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        checkoutText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Alternative cart summary for bottom overlay (like in the image you showed)
class CartSummaryOverlay extends StatelessWidget {
  final double totalAmount;
  final int totalItems;

  const CartSummaryOverlay({
    super.key,
    required this.totalAmount,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total to pay',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  '€${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              '$totalItems item${totalItems > 1 ? 's' : ''}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
