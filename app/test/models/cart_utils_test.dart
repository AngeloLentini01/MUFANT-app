import 'package:flutter_test/flutter_test.dart';
import 'package:app/presentation/models/cart_utils.dart';

void main() {
  test(
    'removeExceedingTickets removes only the last N tickets (lastly added, not all)',
    () {
      // User adds 997 of A, then 5 of B
      final cartItems = {'A': 997, 'B': 5};
      final additionOrder =
          List<String>.filled(997, 'A') + List<String>.filled(5, 'B');
      final maxAllowedTickets = 1000;

      final result = CartUtils.removeExceedingTickets(
        cartItems: cartItems,
        additionOrder: additionOrder,
        maxAllowedTickets: maxAllowedTickets,
      );

      // Should remove 2 from B, leaving 997 A and 3 B
      expect(result['cartItems'], {'A': 997, 'B': 3});
      expect(result['additionOrder'].where((id) => id == 'A').length, 997);
      expect(result['additionOrder'].where((id) => id == 'B').length, 3);
    },
  );
}
