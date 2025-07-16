import 'package:ulid/ulid.dart';
import "package:app/presentation/styles/all.dart";
import "package:app/presentation/views/tabBarPages/shop_page.dart";
import "package:app/presentation/widgets/shop/cart_summary.dart";
import "package:app/presentation/widgets/shop/confirmation_card.dart";
import "package:flutter/material.dart";
import 'package:app/presentation/views/checkout/checkout_page.dart';
import 'package:app/model/cart/cart_model.dart';
import 'package:app/model/cart/cart_item_model.dart';
import 'package:app/model/museum/activity/museum_activity_model.dart';
import 'package:app/data/dbManagers/db_museum_activity_manager.dart';
import 'package:app/model/items/ticket/ticket_model.dart';
import 'package:app/model/items/ticket/museum_activity_charging_rates.dart';
import 'package:app/model/generic/details_model.dart';
import 'package:app/model/museum/activity/type_of_museum_activity_model.dart';
import 'package:app/utils/app_logger.dart';

class CartConfirmationPage extends StatefulWidget {
  final Map<String, int> cartItems;
  final double totalAmount;
  final List<ShopItem> itemList;
  final List<String> additionOrder;

  const CartConfirmationPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.itemList,
    required this.additionOrder,
  });

  @override
  State<CartConfirmationPage> createState() => _CartConfirmationPageState();
}

class _CartConfirmationPageState extends State<CartConfirmationPage> {
  // Call this after any change to cardGroup to keep localAdditionOrder in sync
  void _syncAdditionOrderWithCart() {
    localAdditionOrder = [];
    cardGroup.forEach((id, quantity) {
      for (int i = 0; i < quantity; i++) {
        localAdditionOrder.add(id);
      }
    });
  }

  late Map<String, int> cardGroup;
  late List<String> localAdditionOrder;

  @override
  void initState() {
    super.initState();
    cardGroup = Map<String, int>.from(widget.cartItems);
    localAdditionOrder = List<String>.from(widget.additionOrder);
  }

  double get totalAmount {
    double total = 0;
    cardGroup.forEach((id, quantity) {
      final found = widget.itemList.where((item) => item.id == id);
      if (found.isNotEmpty) {
        final item = found.first;
        total += item.price * quantity;
      }
    });
    return total;
  }

  int get totalItems {
    return cardGroup.values.fold(0, (sum, quantity) => sum + quantity);
  }

  void _removeItem(String itemId) {
    setState(() {
      cardGroup.remove(itemId);
      _syncAdditionOrderWithCart();
    });
  }

  // If you add plus/minus buttons for quantity, call _syncAdditionOrderWithCart() after any change.
  // Example: If you have quantity change logic, call _syncAdditionOrderWithCart() after any change.
  // void _changeQuantity(String itemId, int newQuantity) {
  //   setState(() {
  //     if (newQuantity <= 0) {
  //       cardGroup.remove(itemId);
  //     } else {
  //       cardGroup[itemId] = newQuantity;
  //     }
  //     _syncAdditionOrderWithCart();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default pop behavior since we handle it manually
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, {
            'cartItems': cardGroup,
            'additionOrder': localAdditionOrder,
          });
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kBlackColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context, {
                'cartItems': cardGroup,
                'additionOrder': localAdditionOrder,
              }),
            ),
            centerTitle: true,
            title: Image.asset(
              'assets/images/logo.png',
              height: 40,
              color: Colors.white,
            ),
          ),
          body: cardGroup.isEmpty
              ? Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 120,
                        left: 32,
                        right: 32,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Oops! Your cart's still in hypersleep. Wake it up with a purchase!",
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                          kSpaceBetweenSections,
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: kPinkColor,
                                width: 2,
                              ), // Colored border
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  18,
                                ), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context, {
                                'cartItems': cardGroup,
                                'additionOrder': localAdditionOrder,
                              });
                            },
                            child: Center(
                              child: Text(
                                "Browse Tickets",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kPinkColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        "assets/images/shop_bot/sad_bot_cut.png", // Use your asset path here
                        height: 300, // Adjust size as needed
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    // Cart items list using the same shop cards
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: widget.itemList
                              .where(
                                (item) =>
                                    cardGroup.containsKey(item.id) &&
                                    cardGroup[item.id]! > 0,
                              )
                              .map(
                                (item) => ConfirmationCard(
                                  item: item,
                                  quantity: cardGroup[item.id] ?? 0,
                                  onDelete: () => _removeItem(item.id),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    // Checkout button
                    if (cardGroup.isNotEmpty)
                      CartSummary(
                        totalAmount: totalAmount,
                        totalItems: totalItems,
                        showClearButton:
                            false, // Don't show clear button in cart page
                        showCheckoutButton: true,
                        checkoutText: 'Confirm Checkout',
                        onCheckout: () async {
                          try {
                            // Build a CartModel from the current cartGroup
                            final cartItems = <CartItemModel>[];

                            // Load available activities from database
                            final activitiesData =
                                await DBMuseumActivityManager.getAllActivities();
                            final availableActivities = activitiesData.map((
                              data,
                            ) {
                              final details = DetailsModel(
                                name: data['name'] ?? 'Unknown',
                                description: data['description'] ?? '',
                                notes: data['notes'],
                                imageUrlOrPath: data['image_path'],
                              );

                              return MuseumActivityModel(
                                id: Ulid.parse(data['id'] ?? Ulid().toString()),
                                location: data['location'] ?? 'MUFANT Museum',
                                details: details,
                                type: TypeOfMuseumActivityModel(
                                  id: Ulid(),
                                  details: DetailsModel(
                                    name: data['type'] ?? 'Visit',
                                  ),
                                ),
                                activeTimePeriod: DateTimeRange(
                                  start:
                                      DateTime.tryParse(
                                        data['start_date'] ??
                                            DateTime.now().toIso8601String(),
                                      ) ??
                                      DateTime.now(),
                                  end:
                                      DateTime.tryParse(
                                        data['end_date'] ??
                                            DateTime.now()
                                                .add(const Duration(days: 365))
                                                .toIso8601String(),
                                      ) ??
                                      DateTime.now().add(
                                        const Duration(days: 365),
                                      ),
                                ),
                              );
                            }).toList();

                            for (final entry in cardGroup.entries) {
                              final itemId = entry.key;
                              final quantity = entry.value;

                              // Find the corresponding ShopItem
                              final shopItem = widget.itemList.firstWhere(
                                (item) => item.id == itemId,
                              );

                              // Convert ShopItem to TicketModel
                              final ticketModel = _convertShopItemToTicketModel(
                                shopItem,
                                availableActivities,
                              );

                              // Log ticket creation for debugging
                              AppLogger.info(
                                AppLogger.getLogger('CartConfirmationPage'),
                                'Created ticket for ShopItem: ${shopItem.title} (ID: ${shopItem.id})',
                              );
                              AppLogger.info(
                                AppLogger.getLogger('CartConfirmationPage'),
                                'Ticket event title: ${ticketModel.museumActivity.details.name}',
                              );
                              AppLogger.info(
                                AppLogger.getLogger('CartConfirmationPage'),
                                'Ticket charging rate: ${ticketModel.chargingRate}',
                              );

                              // Add the ticket to cart items (one for each quantity)
                              for (int i = 0; i < quantity; i++) {
                                cartItems.add(ticketModel);
                              }
                            }

                            final cart = CartModel(
                              id: Ulid(),
                              cartItems: cartItems,
                              updatedAt: DateTime.now(),
                            );

                            if (mounted && context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(
                                    cart: cart,
                                    availableActivities: availableActivities,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            AppLogger.error(
                              AppLogger.getLogger('CartConfirmationPage'),
                              'Error during checkout: $e',
                            );
                            if (mounted && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error during checkout: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                  ],
                ),
          // No tab bar in cart confirmation page
        ),
      ),
    );
  }

  /// Convert ShopItem to TicketModel
  TicketModel _convertShopItemToTicketModel(
    ShopItem shopItem,
    List<MuseumActivityModel> availableActivities,
  ) {
    // Find the corresponding museum activity based on shop item
    MuseumActivityModel museumActivity;

    // Try to find a matching activity based on shop item properties
    MuseumActivityModel? matchingActivity = _findMatchingActivity(
      shopItem,
      availableActivities,
    );

    if (matchingActivity != null) {
      museumActivity = matchingActivity;
    } else if (availableActivities.isNotEmpty) {
      // Fallback to first activity if no match found
      museumActivity = availableActivities.first;
    } else {
      // Create a default museum activity if none are available
      final details = DetailsModel(
        name: shopItem.title,
        description: shopItem.subtitle,
      );

      museumActivity = MuseumActivityModel(
        id: Ulid(),
        location: 'MUFANT Museum',
        details: details,
        type: TypeOfMuseumActivityModel(
          id: Ulid(),
          details: DetailsModel(name: 'Museum Visit'),
        ),
        activeTimePeriod: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 365)),
        ),
      );
    }

    // Determine charging rate based on shop item
    MuseumActivityChargingRates chargingRate;
    switch (shopItem.id) {
      case '1':
        chargingRate = MuseumActivityChargingRates.full;
        break;
      case '2':
        chargingRate = MuseumActivityChargingRates
            .uniStudentsOver65AndTurinAIACEAssociates;
        break;
      case '3':
        chargingRate = MuseumActivityChargingRates.disabledAndTurinPiedmontCard;
        break;
      case '4':
        chargingRate = MuseumActivityChargingRates.kidsBetween4And10;
        break;
      case '5':
        chargingRate = MuseumActivityChargingRates.under4;
        break;
      default:
        // For events and tours, use full price
        chargingRate = MuseumActivityChargingRates.full;
    }

    return TicketModel(
      id: Ulid(),
      details: museumActivity.details,
      price: TicketModel.ticketPrices[chargingRate]!,
      quantity: 1,
      chargingRate: chargingRate,
      museumActivity: museumActivity,
    );
  }

  /// Find a matching museum activity based on shop item properties
  MuseumActivityModel? _findMatchingActivity(
    ShopItem shopItem,
    List<MuseumActivityModel> availableActivities,
  ) {
    // For museum tickets (IDs 1-5), use a default MUFANT activity
    if (shopItem.id == '1' ||
        shopItem.id == '2' ||
        shopItem.id == '3' ||
        shopItem.id == '4' ||
        shopItem.id == '5') {
      // Create a default MUFANT museum activity for regular tickets
      final details = DetailsModel(
        name: 'MUFANT Museum Visit',
        description: 'General admission to MUFANT Museum',
      );

      return MuseumActivityModel(
        id: Ulid(),
        location: 'MUFANT Museum',
        details: details,
        type: TypeOfMuseumActivityModel(
          id: Ulid(),
          details: DetailsModel(name: 'Museum Visit'),
        ),
        activeTimePeriod: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 365)),
        ),
      );
    }

    // For events, try to match by title similarity
    for (final activity in availableActivities) {
      final activityName = activity.details.name.toLowerCase();
      final shopItemTitle = shopItem.title.toLowerCase();

      // Check if the shop item title contains or matches the activity name
      if (activityName.contains(shopItemTitle) ||
          shopItemTitle.contains(activityName) ||
          activityName == shopItemTitle) {
        return activity;
      }
    }

    // For tours, create a specific tour activity
    if (shopItem.id.startsWith('tour_')) {
      final details = DetailsModel(
        name: shopItem.title,
        description: shopItem.subtitle,
      );

      return MuseumActivityModel(
        id: Ulid(),
        location: 'MUFANT Museum',
        details: details,
        type: TypeOfMuseumActivityModel(
          id: Ulid(),
          details: DetailsModel(name: 'Guided Tour'),
        ),
        activeTimePeriod: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 365)),
        ),
      );
    }

    // If no match found, return null
    return null;
  }
}
