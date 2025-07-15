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
  int selectedTabIndex = 0;
  Map<String, int> cartItems = {};

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
      cartItems[itemId] = (cartItems[itemId] ?? 0) + 1;
    });
  }

  void _removeFromCart(String itemId) {
    setState(() {
      final currentQuantity = cartItems[itemId] ?? 0;
      if (currentQuantity > 1) {
        cartItems[itemId] = currentQuantity - 1;
      } else {
        cartItems.remove(itemId);
      }
    });
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
    });
    _logger.info('Cart cleared');
  }

  void _setQuantity(String itemId, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        cartItems.remove(itemId);
        _logger.info('Item $itemId removed from cart');
      } else {
        cartItems[itemId] = newQuantity;
        _logger.info('Item $itemId quantity set to $newQuantity');
      }
    });
  }

  void _removeAllOfItem(String itemId) {
    setState(() {
      final removedQuantity = cartItems[itemId] ?? 0;
      cartItems.remove(itemId);
      _logger.info('All $removedQuantity items of $itemId removed from cart');
    });
  }

  void _goToCheckout() async {
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
