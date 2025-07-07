import 'package:flutter/material.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/widgets/all.dart';
import 'package:logging/logging.dart';
import 'dart:async';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  static final Logger _logger = Logger('ShopPage');
  int selectedTabIndex = 0;
  Map<String, int> cartItems = {};
  Timer? _timer;
  String? _activeTimerItemId;
  bool _isIncrementing = false;

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
        child: CustomScrollView(
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
                if (index < filteredItems.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildShopItemCard(filteredItems[index]),
                  );
                } else {
                  // This is the cart summary at the end
                  return totalItems > 0
                      ? _buildCartSummary()
                      : const SizedBox.shrink();
                }
              }, childCount: filteredItems.length + (totalItems > 0 ? 1 : 0)),
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

  Widget _buildShopItemCard(ShopItem item) {
    final quantity = cartItems[item.id] ?? 0;
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
          child: Row(
            children: [
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
                    item.imageAsset,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.museum, color: Colors.white, size: 30);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '€${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isInCart
                    ? Row(
                        key: ValueKey('quantity_controls_${item.id}'),
                        children: [
                          GestureDetector(
                            onTapDown: (_) => _startOperation(item.id, false),
                            onTapUp: (_) => _stopOperation(),
                            onTapCancel: () => _stopOperation(),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              quantity.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTapDown: (_) => _startOperation(item.id, true),
                            onTapUp: (_) => _stopOperation(),
                            onTapCancel: () => _stopOperation(),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        key: ValueKey('add_button_${item.id}'),
                        onPressed: () {
                          setState(() {
                            cartItems[item.id] = 1;
                          });
                          _logger.info('Added ${item.title} to cart');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPinkColor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
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
              //todo: add clear button to remove all items from cart
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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    cartItems.clear();
                  });
                  _logger.info('Cart cleared');
                },
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              // Checkout button
              ElevatedButton(
                onPressed: () {
                  _logger.info('Proceeding to cart with $totalItems items');
                  // TODO: Navigate to cart page or checkout
                },
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
                child: const Text(
                  'Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startOperation(String itemId, bool isIncrementing) {
    // Immediate action
    _performOperation(itemId, isIncrementing);

    // Set up for continuous operation
    _activeTimerItemId = itemId;
    _isIncrementing = isIncrementing;

    // Start continuous operation after a delay
    _timer = Timer(const Duration(milliseconds: 500), () {
      _startContinuousOperation();
    });
  }

  void _startContinuousOperation() {
    if (_activeTimerItemId == null) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_activeTimerItemId == null) {
        timer.cancel();
        return;
      }

      _performOperation(_activeTimerItemId!, _isIncrementing);

      // Stop if item is removed from cart
      if (!_isIncrementing && (cartItems[_activeTimerItemId!] ?? 0) == 0) {
        _stopOperation();
      }
    });
  }

  void _performOperation(String itemId, bool isIncrementing) {
    setState(() {
      if (isIncrementing) {
        cartItems[itemId] = (cartItems[itemId] ?? 0) + 1;
      } else {
        final currentQuantity = cartItems[itemId] ?? 0;
        if (currentQuantity > 1) {
          cartItems[itemId] = currentQuantity - 1;
        } else {
          cartItems.remove(itemId);
        }
      }
    });
  }

  void _stopOperation() {
    _timer?.cancel();
    _activeTimerItemId = null;
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
