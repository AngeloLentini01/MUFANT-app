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
import 'package:easy_localization/easy_localization.dart';

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
      child: Scaffold(
        backgroundColor: kBlackColor,
        appBar: AppBar(
          backgroundColor: kBlackColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context, {
              'cartItems': cardGroup,
              'additionOrder': localAdditionOrder,
            }),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kWhiteColor,
              size: 24,
            ),
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
                              "browse_tickets".tr(),
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
                        // Build a CartModel from the current cartGroup
                        final cartItems = <CartItemModel>[];
                        for (final _ in cardGroup.entries) {
                          // Placeholder: conversion logic goes here
                        }
                        final cart = CartModel(
                          id: Ulid(),
                          cartItems: cartItems,
                          updatedAt: DateTime.now(),
                        );
                        // You also need to provide the list of available activities for ticket creation
                        final availableActivities =
                            <
                              MuseumActivityModel
                            >[]; // TODO: Provide real activities
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              cart: cart,
                              availableActivities: availableActivities,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
        // No tab bar in cart confirmation page
      ),
    );
  }
}
