import 'package:app/presentation/views/cart_confirmation/cart_confirmation_page.dart';
import 'package:app/presentation/models/cart_utils.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/widgets/all.dart';
import 'package:logging/logging.dart';
import 'package:app/data/dbManagers/db_museum_activity_manager.dart';
// import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/models/shop_event_item.dart';

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

  // Guided tour pricing logic
  static const double tourGroupPrice = 60.0;
  static const double tourAdultPrice = 13.0;
  static const double tourReducedPrice = 11.0;
  static const double tourKidsPrice = 11.0;

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

  List<ShopEventItem> eventItems = [];
  bool _eventsLoaded = false;
  @override
  void initState() {
    super.initState();
    _loadEventsForShop();
  }

  Future<void> _loadEventsForShop() async {
    final events = await DBMuseumActivityManager.getEventsAsDetailsModels();
    setState(() {
      eventItems = events
          .map((e) => ShopEventItem.fromDetailsModel(e))
          .toList();
      _eventsLoaded = true;
    });
  }

  List<ShopItem> get filteredItems {
    if (categories[selectedTabIndex] == 'Events') {
      // Convert ShopEventItem to ShopItem for ShopCard compatibility
      return eventItems
          .map(
            (e) => ShopItem(
              id: e.id,
              title: e.title,
              subtitle: e.subtitle,
              price: e.price,
              category: e.category,
              imageAsset: e.imageAsset,
            ),
          )
          .toList();
    } else if (categories[selectedTabIndex] == 'Tours') {
      // Custom guided tour card(s)
      return [
        ShopItem(
          id: 'tour_group',
          title: 'Guided Tour (1-5 participants)',
          subtitle: '90 min. tour for 1 to 5 people (reservation required)',
          price: tourGroupPrice,
          category: 'Tours',
          imageAsset: 'assets/images/logo.png',
        ),
        ShopItem(
          id: 'tour_adult',
          title: 'Guided Tour (Adult, 6+ participants)',
          subtitle: 'Per adult, 90 min. tour (reservation required)',
          price: tourAdultPrice,
          category: 'Tours',
          imageAsset: 'assets/images/logo.png',
        ),
        ShopItem(
          id: 'tour_reduced',
          title: 'Guided Tour (Disabled, 6+ participants)',
          subtitle:
              'Per disabled participant, 90 min. tour (reservation required)',
          price: tourReducedPrice,
          category: 'Tours',
          imageAsset: 'assets/images/logo.png',
        ),
        ShopItem(
          id: 'tour_kid',
          title: 'Guided Tour (Kids 4-10, 6+ participants)',
          subtitle: 'Per kid (4-10 years), 90 min. tour (reservation required)',
          price: tourKidsPrice,
          category: 'Tours',
          imageAsset: 'assets/images/logo.png',
        ),
      ];
    } else {
      return items
          .where((item) => item.category == categories[selectedTabIndex])
          .toList();
    }
  }

  // Helper to get all possible items (museum, events, tours)
  List<ShopItem> get allItems {
    return [
      ...items,
      ...eventItems.map(
        (e) => ShopItem(
          id: e.id,
          title: e.title,
          subtitle: e.subtitle,
          price: e.price,
          category: e.category,
          imageAsset: e.imageAsset,
        ),
      ),
      // Add tour items
      ShopItem(
        id: 'tour_group',
        title: 'Guided Tour (1-5 participants)',
        subtitle: '90 min. tour for 1 to 5 people (reservation required)',
        price: tourGroupPrice,
        category: 'Tours',
        imageAsset: 'assets/images/logo.png',
      ),
      ShopItem(
        id: 'tour_adult',
        title: 'Guided Tour (Adult, 6+ participants)',
        subtitle: 'Per adult, 90 min. tour (reservation required)',
        price: tourAdultPrice,
        category: 'Tours',
        imageAsset: 'assets/images/logo.png',
      ),
      ShopItem(
        id: 'tour_reduced',
        title: 'Guided Tour (Disabled, 6+ participants)',
        subtitle:
            'Per disabled participant, 90 min. tour (reservation required)',
        price: tourReducedPrice,
        category: 'Tours',
        imageAsset: 'assets/images/logo.png',
      ),
      ShopItem(
        id: 'tour_kid',
        title: 'Guided Tour (Kids 4-10, 6+ participants)',
        subtitle: 'Per kid (4-10 years), 90 min. tour (reservation required)',
        price: tourKidsPrice,
        category: 'Tours',
        imageAsset: 'assets/images/logo.png',
      ),
    ];
  }

  double get totalAmount {
    double total = 0;
    cartItems.forEach((id, quantity) {
      final found = allItems.where((item) => item.id == id);
      if (found.isNotEmpty) {
        total += found.first.price * quantity;
      }
    });
    return total;
  }

  int get totalItems {
    return cartItems.values.fold(0, (sum, quantity) => sum + quantity);
  }

  void _addToCart(String itemId) {
    setState(() {
      if (totalItems >= maxAllowedTickets) {
        _showTicketLimitDialog();
        return;
      }
      cartItems[itemId] = (cartItems[itemId] ?? 0) + 1;
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
          // Show the dialog instead of just a snackbar
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
                'Dismiss checkout',
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
                'Remove Lastly added tickets',
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
      _logger.info(
        'Before removal: cartItems=$cartItems, additionOrder=$additionOrder',
      );
      final result = CartUtils.removeExceedingTickets(
        cartItems: cartItems,
        additionOrder: additionOrder,
        maxAllowedTickets: maxAllowedTickets,
      );
      cartItems = Map<String, int>.from(result['cartItems']);
      additionOrder = List<String>.from(result['additionOrder']);
      _logger.info(
        'After removal: cartItems=$cartItems, additionOrder=$additionOrder',
      );
      _logger.info(
        'Removed exceeding tickets (lastly added), new total: $totalItems',
      );
    });
  }

  void _goToCheckout() async {
    // Check if we have too many tickets before proceeding
    if (totalItems > maxAllowedTickets) {
      _showTicketLimitDialog();
      return;
    }

    _logger.info('Proceeding to cart with $totalItems items');
    // Use allItems (museum, events, tours) for confirmation page
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartConfirmationPage(
          cartItems: cartItems,
          totalAmount: totalAmount,
          itemList: allItems,
          additionOrder: List<String>.from(additionOrder),
        ),
      ),
    );

    // Update cart items and additionOrder if changes were made in cart confirmation
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        cartItems = Map<String, int>.from(result['cartItems'] ?? {});
        // Rebuild additionOrder to match cartItems (order is not meaningful after confirmation)
        additionOrder = [];
        cartItems.forEach((id, quantity) {
          for (int i = 0; i < quantity; i++) {
            additionOrder.add(id);
          }
        });
      });
      _logger.info(
        'Cart updated with $totalItems items after returning from cart confirmation (additionOrder rebuilt)',
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
                  },
                  showLogo: false,
                  showAppBarCTAButton: false,
                  additionalContent: Column(
                    children: [_buildSearchBar(), _buildCategoryTabs()],
                  ),
                ),
                if (!_eventsLoaded && categories[selectedTabIndex] == 'Events')
                  const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ShopCard(
                          item: filteredItems[index],
                          cartQuantity: cartItems[filteredItems[index].id] ?? 0,
                          onAddToCart: () =>
                              _addToCart(filteredItems[index].id),
                          onRemoveFromCart: () =>
                              _removeFromCart(filteredItems[index].id),
                          showDeleteButton:
                              (cartItems[filteredItems[index].id] ?? 0) > 0,
                          onDelete: () =>
                              _removeAllOfItem(filteredItems[index].id),
                          onQuantityEdit: (newQuantity) => _setQuantity(
                            filteredItems[index].id,
                            newQuantity,
                          ),
                        ),
                      );
                    }, childCount: filteredItems.length),
                  ),
                if (totalItems > 0)
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
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
