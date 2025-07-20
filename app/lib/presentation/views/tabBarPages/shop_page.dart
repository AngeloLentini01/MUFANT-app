import 'package:app/presentation/views/checkout/cart_confirmation/cart_confirmation_page.dart';
import 'package:app/presentation/models/cart_utils.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/widgets/all.dart';
import 'package:app/presentation/widgets/animated_tab_bar.dart';
import 'package:logging/logging.dart';
import 'package:app/data/dbManagers/db_museum_activity_manager.dart';
import 'package:app/data/services/user_session_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/utils/button_scanner_wrapper.dart';
import 'package:app/presentation/services/search_service.dart';
// import 'package:app/model/generic/details_model.dart';

import 'package:app/presentation/models/shop_event_item.dart';

// Move ShopItem class here, after all imports

class ShopItem implements SearchableItem {
  @override
  final String id;
  @override
  final String title;
  @override
  final String subtitle;
  final double price;
  @override
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

  @override
  String get searchableText => '$title $subtitle $category';
}

typedef GoToProfileCallback = void Function();

class ShopPage extends StatefulWidget {
  final GoToProfileCallback? onGoToProfile;
  const ShopPage({super.key, this.onGoToProfile});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late final SearchService _searchService;

  @override
  void initState() {
    super.initState();
    _searchService = SearchService();
    _loadEventsForShop();
    _pageController = PageController(initialPage: selectedTabIndex);
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
            hintText: 'search'.tr(),
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onTap: _onSearchPressed,
          readOnly: true,
        ),
      ),
    );
  }

  Future<void> _onSearchPressed() async {
    if (!mounted) return;

    // Get only shop-specific searchable items (museum tickets and tours only)
    final shopSearchableItems = <SearchableItem>[];

    // Add museum ticket items
    shopSearchableItems.addAll(items);

    // Add tour items
    shopSearchableItems.addAll([
      ShopItem(
        id: 'tour_group',
        title: 'guided_tour_group'.tr(),
        subtitle: 'guided_tour_group_subtitle'.tr(),
        price: tourGroupPrice,
        category: 'tours'.tr(),
        imageAsset: 'assets/images/logo.png',
      ),
      ShopItem(
        id: 'tour_adult',
        title: 'guided_tour_adult'.tr(),
        subtitle: 'guided_tour_adult_subtitle'.tr(),
        price: tourAdultPrice,
        category: 'tours'.tr(),
        imageAsset: 'assets/images/logo.png',
      ),
      ShopItem(
        id: 'tour_reduced',
        title: 'guided_tour_disabled'.tr(),
        subtitle: 'guided_tour_disabled_subtitle'.tr(),
        price: tourReducedPrice,
        category: 'tours'.tr(),
        imageAsset: 'assets/images/logo.png',
      ),
      ShopItem(
        id: 'tour_kid',
        title: 'guided_tour_kid'.tr(),
        subtitle: 'guided_tour_kid_subtitle'.tr(),
        price: tourKidsPrice,
        category: 'tours'.tr(),
        imageAsset: 'assets/images/logo.png',
      ),
    ]);

    showDialog(
      context: context,
      builder: (context) => SearchDialog<SearchableItem>(
        title: 'Shop Search',
        items: shopSearchableItems,
        searchService: _searchService,
        hintText: 'Search tickets and tours...',
        onItemSelected: (item, matchedText) {
          _onSearchItemSelected(item, matchedText);
        },
      ),
    );
  }

  void _onSearchItemSelected(SearchableItem item, String matchedText) {
    // Since we only include ShopItem types in shop search, handle only those
    if (item is ShopItem) {
      _navigateToShopItem(item, matchedText);
    }
  }

  void _navigateToShopItem(ShopItem item, String matchedText) {
    // Switch to the appropriate tab based on category
    int targetTabIndex = 0; // Default to museum tab

    if (item.category == 'Events') {
      targetTabIndex = 1;
    } else if (item.category == 'Tours') {
      targetTabIndex = 2;
    }

    // Switch to the appropriate tab
    setState(() {
      selectedTabIndex = targetTabIndex;
    });
    _pageController.animateToPage(
      targetTabIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  // Removed PageController
  static final Logger _logger = Logger('ShopPage');
  static const int maxAllowedTickets = 1000;
  int selectedTabIndex = 0;
  late final PageController _pageController;
  Map<String, int> cartItems = {};
  List<String> additionOrder = []; // Track the order items were added

  List<String> get categories => ['museum'.tr(), 'events'.tr(), 'tours'.tr()];

  // Guided tour pricing logic
  static const double tourGroupPrice = 60.0;
  static const double tourAdultPrice = 13.0;
  static const double tourReducedPrice = 11.0;
  static const double tourKidsPrice = 11.0;

  List<ShopItem> get items => [
    ShopItem(
      id: '1',
      title: 'mufant_full_price'.tr(),
      subtitle: 'age_over_10'.tr(),
      price: 8.00,
      category: 'museum'.tr(),
      imageAsset: 'assets/images/logo.png',
    ),
    ShopItem(
      id: '2',
      title: 'mufant_reduced_price'.tr(),
      subtitle: 'university_students'.tr(),
      price: 7.00,
      category: 'museum'.tr(),
      imageAsset: 'assets/images/logo.png',
    ),
    ShopItem(
      id: '3',
      title: 'mufant_reduced_price'.tr(),
      subtitle: 'disabled_people'.tr(),
      price: 6.00,
      category: 'museum'.tr(),
      imageAsset: 'assets/images/logo.png',
    ),
    ShopItem(
      id: '4',
      title: 'mufant_kids'.tr(),
      subtitle: 'age_4_to_10'.tr(),
      price: 5.00,
      category: 'museum'.tr(),
      imageAsset: 'assets/images/logo.png',
    ),
    ShopItem(
      id: '5',
      title: 'mufant_free'.tr(),
      subtitle: 'ticket_discount_info'.tr(),
      price: 0.00,
      category: 'museum'.tr(),
      imageAsset: 'assets/images/logo.png',
    ),
  ];

  List<ShopEventItem> eventItems = [];
  bool _eventsLoaded = false;

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
    if (categories[selectedTabIndex] == 'events'.tr()) {
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
    } else if (categories[selectedTabIndex] == 'tours'.tr()) {
      // Custom guided tour card(s)
      return [
        ShopItem(
          id: 'tour_group',
          title: 'guided_tour_group'.tr(),
          subtitle: 'guided_tour_group_subtitle'.tr(),
          price: tourGroupPrice,
          category: 'tours'.tr(),
          imageAsset: 'assets/images/logo.png',
        ),
        ShopItem(
          id: 'tour_adult',
          title: 'guided_tour_adult'.tr(),
          subtitle: 'guided_tour_adult_subtitle'.tr(),
          price: tourAdultPrice,
          category: 'tours'.tr(),
          imageAsset: 'assets/images/logo.png',
        ),
        ShopItem(
          id: 'tour_reduced',
          title: 'guided_tour_disabled'.tr(),
          subtitle: 'guided_tour_disabled_subtitle'.tr(),
          price: tourReducedPrice,
          category: 'tours'.tr(),
          imageAsset: 'assets/images/logo.png',
        ),
        ShopItem(
          id: 'tour_kid',
          title: 'guided_tour_kid'.tr(),
          subtitle: 'guided_tour_kid_subtitle'.tr(),
          price: tourKidsPrice,
          category: 'tours'.tr(),
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
              Expanded(
                child: Text(
                  'too_many_tickets'.tr(),
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
            "max_tickets_error".tr(
              namedArgs: {'maxTickets': maxAllowedTickets.toString()},
            ),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearCart(); // Clear all tickets when dismissing checkout
              },
              child: Text(
                'dismiss_checkout'.tr(),
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
              child: Text(
                'remove_lastly_added_tickets'.tr(),
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
        'Removed exceeding tickets (most recently added), new total: $totalItems',
      );
    });
  }

  void _goToCheckout() async {
    // Check if we have too many tickets before proceeding
    if (totalItems > maxAllowedTickets) {
      _showTicketLimitDialog();
      return;
    }

    // Check if user is logged in
    final isLoggedIn = await UserSessionManager.isLoggedIn();
    if (!isLoggedIn) {
      // Use callback to switch to profile tab in AppMain
      if (widget.onGoToProfile != null) {
        widget.onGoToProfile!();
        // Wait for navigation to complete before showing dialog
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        // Only use context if still mounted
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.lock, color: kPinkColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  'login_required'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'user_login_required_message'.tr(),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'got_it'.tr(),
                  style: TextStyle(
                    color: kPinkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return;
    }

    _logger.info('Proceeding to cart with $totalItems items');
    // Use allItems (museum, events, tours) for confirmation page
    if (!mounted) return;
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
    if (!mounted) return;
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
    return ButtonScannerWrapper(
      pageName: 'ShopPage',
      child: SafeArea(
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
              Column(
                children: [
                  Container(
                    color: kBlackColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'shop_title'.tr(),
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Add more actions if needed
                      ],
                    ),
                  ),
                  _buildSearchBar(), // Ensure _buildSearchBar is defined and used correctly
                  AnimatedTabBar(
                    tabs: categories,
                    selectedIndex: selectedTabIndex,
                    onTabSelected: (index) {
                      setState(() {
                        selectedTabIndex = index;
                      });
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: categories.length,
                      onPageChanged: (index) {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                      itemBuilder: (context, pageIndex) {
                        if (!_eventsLoaded &&
                            categories[pageIndex] == 'Events') {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final itemsForPage = () {
                          if (categories[pageIndex] == 'Events') {
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
                          } else if (categories[pageIndex] == 'Tours') {
                            return [
                              ShopItem(
                                id: 'tour_group',
                                title: 'Guided Tour (1-5 participants)',
                                subtitle:
                                    '90 min. tour for 1 to 5 people (reservation required)',
                                price: tourGroupPrice,
                                category: 'Tours',
                                imageAsset: 'assets/images/logo.png',
                              ),
                              ShopItem(
                                id: 'tour_adult',
                                title: 'Guided Tour (Adult, 6+ participants)',
                                subtitle:
                                    'Per adult, 90 min. tour (reservation required)',
                                price: tourAdultPrice,
                                category: 'Tours',
                                imageAsset: 'assets/images/logo.png',
                              ),
                              ShopItem(
                                id: 'tour_reduced',
                                title:
                                    'Guided Tour (Disabled, 6+ participants)',
                                subtitle:
                                    'Per disabled participant, 90 min. tour (reservation required)',
                                price: tourReducedPrice,
                                category: 'Tours',
                                imageAsset: 'assets/images/logo.png',
                              ),
                              ShopItem(
                                id: 'tour_kid',
                                title:
                                    'Guided Tour (Kids 4-10, 6+ participants)',
                                subtitle:
                                    'Per kid (4-10 years), 90 min. tour (reservation required)',
                                price: tourKidsPrice,
                                category: 'Tours',
                                imageAsset: 'assets/images/logo.png',
                              ),
                            ];
                          } else {
                            return items
                                .where(
                                  (item) =>
                                      item.category == categories[pageIndex],
                                )
                                .toList();
                          }
                        }();
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: itemsForPage.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minHeight: 176,
                                ),
                                child: ShopCard(
                                  item: itemsForPage[index],
                                  cartQuantity:
                                      cartItems[itemsForPage[index].id] ?? 0,
                                  onAddToCart: () =>
                                      _addToCart(itemsForPage[index].id),
                                  onRemoveFromCart: () =>
                                      _removeFromCart(itemsForPage[index].id),
                                  showDeleteButton:
                                      (cartItems[itemsForPage[index].id] ?? 0) >
                                      0,
                                  onDelete: () =>
                                      _removeAllOfItem(itemsForPage[index].id),
                                  onQuantityEdit: (newQuantity) => _setQuantity(
                                    itemsForPage[index].id,
                                    newQuantity,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              AnimatedSlide(
                offset: totalItems > 0 ? Offset(0, 0) : Offset(0, 1),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CartSummary(
                    totalAmount: totalAmount,
                    totalItems: totalItems,
                    onClearCart: _clearCart,
                    onCheckout: _goToCheckout,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _buildCategoryTabs removed, now using AnimatedTabBar

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
