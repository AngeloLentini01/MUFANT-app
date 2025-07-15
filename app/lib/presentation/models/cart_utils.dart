class CartUtils {
  /// Removes the last [excessTickets] tickets from [additionOrder] and updates [cartItems] accordingly.
  /// Returns a tuple of the new cartItems and additionOrder.
  static Map<String, dynamic> removeExceedingTickets({
    required Map<String, int> cartItems,
    required List<String> additionOrder,
    required int maxAllowedTickets,
  }) {
    final newCartItems = Map<String, int>.from(cartItems);
    final newAdditionOrder = List<String>.from(additionOrder);

    // Remove excess tickets in reverse order of addition (last in, first out), regardless of type
    int currentTotal = newCartItems.values.fold(0, (sum, q) => sum + q);
    int toRemove = currentTotal - maxAllowedTickets;
    while (toRemove > 0 && newAdditionOrder.isNotEmpty) {
      String itemId = newAdditionOrder.removeLast();
      if (newCartItems.containsKey(itemId)) {
        newCartItems[itemId] = newCartItems[itemId]! - 1;
        if (newCartItems[itemId]! <= 0) {
          newCartItems.remove(itemId);
        }
        toRemove--;
      }
    }

    return {'cartItems': newCartItems, 'additionOrder': newAdditionOrder};
  }
}
