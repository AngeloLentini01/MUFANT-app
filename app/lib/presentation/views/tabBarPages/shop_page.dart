import 'package:app/presentation/views/cart_confirmation/cart_confirmation_page.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/widgets/all.dart';
import 'package:logging/logging.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  static final Logger _logger = Logger('ShopPage');
  static const int maxAllowedTickets = 1000;
  int selectedTabIndex = 0;
  Map<String, int> cartItems = {};
  List<String> additionOrder = []; // Track the order items were added

  final List<String> categories = ['Museum', 'Events', 'Tours'];

  final List<ShopItem> items = [
    ShopItem(
      id: '1',
      title: 'MUFANT - Full price',
      subtitle: '> 10 years',
      price: 8.00,
      category: 'Museum',
      imageAsset: 'assets/images/logo.png',
    ),
    ShopItem(
      id: '2',
      title: 'MUFANT - Reduced price',
      subtitle:
          'University students;\nSenior over 65 years;\nAIACE Torino Partners',
      price: 7.00,
      category: 'Museum',
      imageAsset: 'assets/images/logo.png',
    ),
    ShopItem(
      id: '3',
      title: 'MUFANT - Reduced price',
      subtitle:
          'disabled people (free companion);\npossessors Torino+Piemonte Card',
      price: 6.00,
      category: 'Museum',
      imageAsset: 'assets/images/logo.png',
    ),
    ShopItem(
      id: '4',
      title: 'MUFANT - Kids',
      subtitle: 'From 4 to 10 years',
      price: 5.00,
      category: 'Museum',
      imageAsset: 'assets/images/logo.png',
    ),
    ShopItem(
      id: '5',
      title: 'MUFANT - Free',
      subtitle:
          '< 4 years;\npossessors "Abbonamento Musei Piemonte e Valle d\'Aosta"',
      price: 0.00,
      category: 'Museum',
      imageAsset: 'assets/images/logo.png',
    ),
  ];

  List<ShopItem> get filteredItems {
    return items
        .where((item) => item.category == categories[selectedTabIndex])
        .toList();
  }

  double get totalAmount {
    double total = 0;
    cartItems.forEach((id, quantity) {
      final item = items.firstWhere((item) => item.id == id);
      total += item.price * quantity;
    });
    return total;
  }

  int get totalItems {
    return cartItems.values.fold(0, (sum, quantity) => sum + quantity);
  }

  void _addToCart(String itemId) {
    setState(() {
      // Check if adding one more would exceed the limit
      if (totalItems >= maxAllowedTickets) {
        // Show the dialog
        _showTicketLimitDialog();
        return;
      }

      // If this is the first time adding this item, track it
      if (!cartItems.containsKey(itemId)) {
        additionOrder.add(itemId);
      }

      cartItems[itemId] = (cartItems[itemId] ?? 0) + 1;
      // Also add to the order for each individual ticket
      additionOrder.add(itemId);
    });
  }

  void _removeFromCart(String itemId) {
    setState(() {
      final currentQuantity = cartItems[itemId] ?? 0;
      if (currentQuantity > 1) {
        cartItems[itemId] = currentQuantity - 1;
        // Remove the last occurrence of this item from the order
        for (int i = additionOrder.length - 1; i >= 0; i--) {
          if (additionOrder[i] == itemId) {
            additionOrder.removeAt(i);
            break;
          }
        }
      } else {
        cartItems.remove(itemId);
        // Remove all occurrences of this item from the order
        additionOrder.removeWhere((id) => id == itemId);
      }
    });
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
      additionOrder.clear(); // Also clear the order tracking
    });
    _logger.info('Cart cleared');
  }

  void _setQuantity(String itemId, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        cartItems.remove(itemId);
        // Remove all occurrences of this item from the order
        additionOrder.removeWhere((id) => id == itemId);
        _logger.info('Item $itemId removed from cart');
      } else {
        // Check if setting this quantity would exceed the limit
        final currentQuantity = cartItems[itemId] ?? 0;
        final newTotal = totalItems - currentQuantity + newQuantity;
        if (newTotal > maxAllowedTickets) {
          // Show the dialog but DON'T update the cart yet
          _logger.info(
            'Quantity change would exceed limit. Current: $totalItems, Requested total: $newTotal',
          );
          // We need to temporarily update the cart to reflect the new state for the dialog
          cartItems[itemId] = newQuantity;

          // Update order tracking for the temporary state
          if (newQuantity > currentQuantity) {
            // Adding tickets - add to order
            for (int i = 0; i < (newQuantity - currentQuantity); i++) {
              additionOrder.add(itemId);
            }
          } else if (newQuantity < currentQuantity) {
            // Removing tickets - remove from order (last added first)
            int toRemove = currentQuantity - newQuantity;
            for (int i = 0; i < toRemove; i++) {
              for (int j = additionOrder.length - 1; j >= 0; j--) {
                if (additionOrder[j] == itemId) {
                  additionOrder.removeAt(j);
                  break;
                }
              }
            }
          }

          _showTicketLimitDialog();
          return;
        }

        // Update order tracking
        if (newQuantity > currentQuantity) {
          // Adding tickets - add to order
          for (int i = 0; i < (newQuantity - currentQuantity); i++) {
            additionOrder.add(itemId);
          }
        } else if (newQuantity < currentQuantity) {
          // Removing tickets - remove from order (last added first)
          int toRemove = currentQuantity - newQuantity;
          for (int i = 0; i < toRemove; i++) {
            for (int j = additionOrder.length - 1; j >= 0; j--) {
              if (additionOrder[j] == itemId) {
                additionOrder.removeAt(j);
                break;
              }
            }
          }
        }

        cartItems[itemId] = newQuantity;
        _logger.info('Item $itemId quantity set to $newQuantity');
      }
    });
  }

  void _removeAllOfItem(String itemId) {
    setState(() {
      final removedQuantity = cartItems[itemId] ?? 0;
      cartItems.remove(itemId);
      // Remove all occurrences of this item from the order
      additionOrder.removeWhere((id) => id == itemId);
      _logger.info('All $removedQuantity items of $itemId removed from cart');
    });
  }

  void _showTicketLimitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: kPinkColor, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Too Many Tickets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            "We're sorry. Unfortunately, the museum can't host more than $maxAllowedTickets visitors.",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearCart(); // Clear all tickets when dismissing checkout
              },
              child: Text(
                'Dismiss Checkout',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeExceedingTickets();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPinkColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Remove Exceeding Tickets',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeExceedingTickets() {
    setState(() {
      int currentTotal = totalItems;
      if (currentTotal > maxAllowedTickets) {
        int excessTickets = currentTotal - maxAllowedTickets;
        int removedCount = 0;

        // Remove from the end of additionOrder (LIFO - Last In First Out)
        while (removedCount < excessTickets && additionOrder.isNotEmpty) {
          // Get the last added item
          String lastItemId = additionOrder.last;

          // Remove this ticket from cart
          if (cartItems.containsKey(lastItemId) && cartItems[lastItemId]! > 0) {
            cartItems[lastItemId] = cartItems[lastItemId]! - 1;

            // If quantity becomes 0, remove the item completely
            if (cartItems[lastItemId] == 0) {
              cartItems.remove(lastItemId);
            }

            // Remove from addition order (remove the last entry)
            additionOrder.removeLast();
            removedCount++;
          } else {
            // If for some reason the item doesn't exist in cart, just remove from order
            additionOrder.removeLast();
          }
        }

        _logger.info(
          'Removed exactly $removedCount excess tickets (lastly added), new total: $totalItems',
        );
      }
    });
  }

  void _goToCheckout() async {
    // Check if we have too many tickets before proceeding
    if (totalItems > maxAllowedTickets) {
      _showTicketLimitDialog();
      return;
    }

    _logger.info('Proceeding to cart with $totalItems items');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartConfirmationPage(
          cartItems: cartItems,
          totalAmount: totalAmount,
          itemList: items,
        ),
      ),
    );

    // Update cart items if changes were made in cart confirmation
    if (result != null && result is Map<String, int>) {
      setState(() {
        cartItems = result;
        // Rebuild the addition order based on current cart items
        // This is a simplified approach - in a real app, you might want to persist the order
        additionOrder.clear();
        cartItems.forEach((itemId, quantity) {
          for (int i = 0; i < quantity; i++) {
            additionOrder.add(itemId);
          }
        });
      });
      _logger.info(
        'Cart updated with $totalItems items after returning from cart confirmation',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
        ),
        child: Stack(
          children: [
            // Main content with CustomScrollView
            CustomScrollView(
              slivers: [
                AppBarWidget(
                  textColor: kWhiteColor,
                  backgroundColor: kBlackColor,
                  logger: _logger,
                  iconImage: Icons.shopping_cart,
                  text: 'Shop',
                  onButtonPressed: () {
                    _logger.info('Shop app bar button pressed');
                    // TODO: Implement shop-specific action
                  },
                  showLogo: false, // Don't show logo on shop page
                  showAppBarCTAButton: false, // Hide button on shop page
                  additionalContent: Column(
                    children: [_buildSearchBar(), _buildCategoryTabs()],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ShopCard(
                        item: filteredItems[index],
                        cartQuantity: cartItems[filteredItems[index].id] ?? 0,
                        onAddToCart: () => _addToCart(filteredItems[index].id),
                        onRemoveFromCart: () =>
                            _removeFromCart(filteredItems[index].id),
                        showDeleteButton:
                            (cartItems[filteredItems[index].id] ?? 0) > 0,
                        onDelete: () =>
                            _removeAllOfItem(filteredItems[index].id),
                        onQuantityEdit: (newQuantity) =>
                            _setQuantity(filteredItems[index].id, newQuantity),
                      ),
                    );
                  }, childCount: filteredItems.length),
                ),
                // Add bottom padding to prevent content from being hidden behind cart summary
                if (totalItems > 0)
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                    ), // Height of cart summary + padding
                  ),
              ],
            ),
            // Cart summary snapped to the bottom
            if (totalItems > 0)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CartSummary(
                  totalAmount: totalAmount,
                  totalItems: totalItems,
                  onClearCart: _clearCart,
                  onCheckout: _goToCheckout,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isSelected = selectedTabIndex == index;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => setState(() => selectedTabIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? kPinkColor : Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ShopItem {
  final String id;
  final String title;
  final String subtitle;
  final double price;
  final String category;
  final String imageAsset;

  ShopItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.category,
    required this.imageAsset,
  });
}
