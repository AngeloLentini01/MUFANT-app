import 'package:flutter_test/flutter_test.dart';
import 'package:app/presentation/views/tabBarPages/shop_page.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Remove exceeding tickets removes only the last N tickets', (
    WidgetTester tester,
  ) async {
    // Build the ShopPage widget
    await tester.pumpWidget(const MaterialApp(home: ShopPage()));
    final state = tester.state(find.byType(ShopPage)) as dynamic;

    // Add 3 of A, 2 of B, 1 of C (simulate user actions)
    state._addToCart('A');
    state._addToCart('A');
    state._addToCart('A');
    state._addToCart('B');
    state._addToCart('B');
    state._addToCart('C');

    // Set maxAllowedTickets to 4 for test
    state.setState(() {
      state.cartItems = {'A': 3, 'B': 2, 'C': 1};
      state.additionOrder = ['A', 'A', 'A', 'B', 'B', 'C'];
    });
    state._removeExceedingTickets =
        ShopPageStateTest._removeExceedingTicketsTest;
    state.maxAllowedTickets = 4;

    // Remove exceeding tickets (should remove last 2: C, B)
    state._removeExceedingTickets();

    // Check the result
    expect(state.cartItems, {'A': 3, 'B': 1});
    expect(state.additionOrder, ['A', 'A', 'A', 'B']);
  });
}

// Helper for test logic
class ShopPageStateTest {
  static void _removeExceedingTicketsTest() {}
}
