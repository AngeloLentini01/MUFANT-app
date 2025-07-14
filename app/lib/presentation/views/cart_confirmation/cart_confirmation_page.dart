import "package:app/presentation/styles/all.dart";
import "package:app/presentation/views/tabBarPages/shop_page.dart";
import "package:app/presentation/widgets/bars/tabBar/my_tab_bar.dart";
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          //TODO: appbar
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShopPage(),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              "Browse Tickets",
                              style: TextStyle(fontSize: 16, color: kPinkColor),
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
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.itemList
                        .where(
                          (item) =>
                              cardGroup.containsKey(item.id) &&
                              cardGroup[item.id]! > 0,
                        )
                        .map((item) => _shopCard(item))
                        .toList(),
                  ),
                ),
              ),
        bottomNavigationBar: MyTabBar(backgroundColor: kBlackColor),
      ),
    );
  }

  Widget _shopCard(ShopItem item) {
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
            ],
          ),
        ),
      ),
    );
  }
}
