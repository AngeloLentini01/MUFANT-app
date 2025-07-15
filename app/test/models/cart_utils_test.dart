import 'package:flutter_test/flutter_test.dart';
import 'package:app/presentation/models/cart_utils.dart';

void main() {
  test(
    'removeExceedingTickets removes only the last N tickets (lastly added, not all)',
    () {
      // User adds 3 reduced, then 1000 full
      final cartItems = {'A': 1000, 'B': 3};
      final additionOrder =
          List<String>.filled(3, 'B') + List<String>.filled(1000, 'A');
      final maxAllowedTickets = 1000;

      // Add 3 more tickets to exceed
      final cartItemsExceed = Map<String, int>.from(cartItems);
      cartItemsExceed['A'] = 1000;
      cartItemsExceed['B'] = 3;
      final additionOrderExceed = List<String>.from(additionOrder);
      additionOrderExceed.addAll(['A', 'A', 'A']); // Add 3 more full price
      cartItemsExceed['A'] = 1003;

      final result = CartUtils.removeExceedingTickets(
        cartItems: cartItemsExceed,
        additionOrder: additionOrderExceed,
        maxAllowedTickets: maxAllowedTickets,
      );

      // Should remove 3 from full price (A), not all
      expect(result['cartItems'], {'A': 1000, 'B': 3});
      expect(result['additionOrder'].where((id) => id == 'A').length, 1000);
      expect(result['additionOrder'].where((id) => id == 'B').length, 3);
    },
  );
  test('removeExceedingTickets removes only the last N tickets', () {
    final cartItems = {'A': 997, 'B': 4};
    final additionOrder = ['A', 'B'];
    final maxAllowedTickets = 1000;

    final result = CartUtils.removeExceedingTickets(
      cartItems: cartItems,
      additionOrder: additionOrder,
      maxAllowedTickets: maxAllowedTickets,
    );

    expect(result['cartItems'], {'A': 997, 'B': 3});
  });
}
