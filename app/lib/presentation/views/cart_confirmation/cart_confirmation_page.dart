import "package:app/presentation/styles/all.dart";
import "package:app/presentation/views/tabBarPages/shop_page.dart";
import "package:app/presentation/widgets/bars/tabBar/my_tab_bar.dart";
import "package:app/presentation/widgets/shop/cart_summary.dart";
import "package:app/presentation/widgets/shop/confirmation_card.dart";
import "package:flutter/material.dart";

class CartConfirmationPage extends StatefulWidget {
  final Map<String, int> cartItems;
  final double totalAmount;
  final List<ShopItem> itemList;

  const CartConfirmationPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.itemList,
  });

  @override
  State<CartConfirmationPage> createState() => _CartConfirmationPageState();
}

class _CartConfirmationPageState extends State<CartConfirmationPage> {
  late Map<String, int> cardGroup;

  @override
  void initState() {
    super.initState();
    cardGroup = Map<String, int>.from(
      widget.cartItems,
    ); // Initialize with cartItems
  }

  double get totalAmount {
    double total = 0;
    cardGroup.forEach((id, quantity) {
      final item = widget.itemList.firstWhere((item) => item.id == id);
      total += item.price * quantity;
    });
    return total;
  }

  int get totalItems {
    return cardGroup.values.fold(0, (sum, quantity) => sum + quantity);
  }

  void _removeItem(String itemId) {
    setState(() {
      cardGroup.remove(itemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default pop behavior since we handle it manually
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, cardGroup);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kBlackColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context, cardGroup),
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
                              Navigator.pop(context, cardGroup);
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
                        onCheckout: () {
                          // TODO: Navigate to checkout
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Proceeding to checkout with $totalItems tickets',
                              ),
                              backgroundColor: kPinkColor,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                  ],
                ),
          bottomNavigationBar: MyTabBar(backgroundColor: kBlackColor),
        ),
      ),
    );
  }
}
