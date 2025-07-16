import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/tabBarPages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

class ShopCard extends StatefulWidget {
  final ShopItem item;
  final int cartQuantity;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;
  final bool showDeleteButton;
  final VoidCallback? onDelete;
  final Function(int)? onQuantityEdit;

  const ShopCard({
    super.key,
    required this.item,
    required this.cartQuantity,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    this.showDeleteButton = false,
    this.onDelete,
    this.onQuantityEdit,
  });

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  static final Logger _logger = Logger('ShopCard');
  Timer? _timer;
  bool _isOperationActive = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startContinuousOperation(bool isIncrementing) {
    _logger.fine(
      'Starting continuous operation: ${isIncrementing ? 'increment' : 'decrement'}',
    );
    _isOperationActive = true;

    // Immediate action
    if (isIncrementing) {
      widget.onAddToCart();
    } else {
      widget.onRemoveFromCart();
    }

    // Start continuous operation after a delay
    _timer = Timer(const Duration(milliseconds: 300), () {
      if (!_isOperationActive) return;

      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!_isOperationActive) {
          timer.cancel();
          return;
        }

        _logger.finest('Continuous operation tick');
        if (isIncrementing) {
          widget.onAddToCart();
        } else {
          if (widget.cartQuantity > 0) {
            widget.onRemoveFromCart();
          } else {
            _stopContinuousOperation();
          }
        }
      });
    });
  }

  void _stopContinuousOperation() {
    _logger.fine('Stopping continuous operation');
    _isOperationActive = false;
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _showQuantityEditDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController(
      text: widget.cartQuantity.toString(),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text(
            'edit_quantity'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'enter_quantity'.tr(),
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onSubmitted: (value) {
              final quantity = int.tryParse(value);
              if (quantity != null && quantity >= 0) {
                Navigator.of(context).pop(quantity);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr(), style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                final quantity = int.tryParse(controller.text);
                if (quantity != null && quantity >= 0) {
                  Navigator.of(context).pop(quantity);
                }
              },
              child: Text('ok'.tr(), style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (result != null && widget.onQuantityEdit != null) {
      widget.onQuantityEdit!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quantity = widget.cartQuantity;
    final isInCart = quantity > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[850]!, Colors.grey[800]!],
          ),
          border: Border.all(
            color: kPinkColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Image + Title + Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image (top left)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [kPinkColor.withValues(alpha: 0.8), kPinkColor],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.asset(
                        widget.item.imageAsset,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.museum,
                            color: Colors.white,
                            size: 30,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title (center, expanded)
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Price (top right)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    child: Text(
                      '€${widget.item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Description and buttons row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description text (expandable, truncates when buttons overflow)
                  if (widget.item.subtitle.isNotEmpty)
                    Expanded(
                      child: Text(
                        widget.item.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(width: 16),
                  // Delete button (only shown in cart view)
                  if (widget.showDeleteButton && widget.onDelete != null) ...[
                    IconButton(
                      onPressed: widget.onDelete,
                      icon: Icon(
                        Icons.delete_outline,
                        color: kPinkColor,
                        size: 24,
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                    const SizedBox(width: 8),
                  ],
                  // Quantity controls or Add button (right side)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: isInCart
                        ? Container(
                            key: ValueKey('quantity_$quantity'),
                            height: 44, // Fixed height to prevent movement
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IntrinsicWidth(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Listener(
                                    onPointerDown: (_) {
                                      _logger.fine('Minus button pointer down');
                                      _startContinuousOperation(false);
                                    },
                                    onPointerUp: (_) {
                                      _logger.fine('Minus button pointer up');
                                      _stopContinuousOperation();
                                    },
                                    onPointerCancel: (_) {
                                      _logger.fine(
                                        'Minus button pointer cancel',
                                      );
                                      _stopContinuousOperation();
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        _showQuantityEditDialog(context),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                      ), // Minimum width for numbers
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12, // Reduced padding
                                        vertical:
                                            8, // Add vertical padding for better tap area
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.transparent,
                                      ),
                                      child: Text(
                                        quantity.toString(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Listener(
                                    onPointerDown: (_) {
                                      _logger.fine('Plus button pointer down');
                                      _startContinuousOperation(true);
                                    },
                                    onPointerUp: (_) {
                                      _logger.fine('Plus button pointer up');
                                      _stopContinuousOperation();
                                    },
                                    onPointerCancel: (_) {
                                      _logger.fine(
                                        'Plus button pointer cancel',
                                      );
                                      _stopContinuousOperation();
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              key: const ValueKey('add_button'),
                              height: 44, // Same height as quantity controls
                              child: ElevatedButton(
                                onPressed: widget.onAddToCart,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPinkColor,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: const Size(
                                    0,
                                    44,
                                  ), // Ensure consistent height
                                ),
                                child: const Text(
                                  'Add',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
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
