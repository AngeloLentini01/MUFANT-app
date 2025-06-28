import 'package:flutter/material.dart';
import 'package:app/presentation/styles/colors/generic.dart';
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
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryTabs(),
            Expanded(child: _buildItemsList()),
            if (totalItems > 0) _buildCartSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo_senza_scritta.png',
            height: 40,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Text(
                'MUFANT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildItemsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildShopItemCard(item);
      },
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
              if (isInCart)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            cartItems[item.id] = quantity - 1;
                          } else {
                            cartItems.remove(item.id);
                          }
                        });
                      },
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
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
                    IconButton(
                      onPressed: () {
                        setState(() {
                          cartItems[item.id] = quantity + 1;
                        });
                      },
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              else
                ElevatedButton(
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
              Text(
                '$totalItems item${totalItems > 1 ? 's' : ''}',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              _logger.info('Proceeding to cart with $totalItems items');
              // TODO: Navigate to cart page or checkout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPinkColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Cart',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
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
