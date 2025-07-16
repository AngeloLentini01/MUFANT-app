import 'package:app/presentation/models/cart_utils.dart';
import 'package:app/utils/app_logger.dart';

void main() {
  // User adds 3 reduced, then 1000 full
  final cartItems = {'A': 1000, 'B': 3};
  final additionOrder =
      List<String>.filled(3, 'B') + List<String>.filled(1000, 'A');
  final maxAllowedTickets = 1000;

  // Add 3 more tickets to exceed
  final cartItemsExceed = Map<String, int>.from(cartItems);
  cartItemsExceed['A'] = 1003; // Start with 1003 A tickets
  cartItemsExceed['B'] = 3;
  final additionOrderExceed = List<String>.from(additionOrder);
  additionOrderExceed.addAll(['A', 'A', 'A']); // Add 3 more full price

  final logger = AppLogger.getLogger('TestDebug');
  AppLogger.info(logger, 'Initial cartItems: $cartItemsExceed');
  AppLogger.info(
    logger,
    'Initial additionOrder length: ${additionOrderExceed.length}',
  );
  AppLogger.info(
    logger,
    'Last 10 items in additionOrder: ${additionOrderExceed.skip(additionOrderExceed.length - 10).toList()}',
  );

  final result = CartUtils.removeExceedingTickets(
    cartItems: cartItemsExceed,
    additionOrder: additionOrderExceed,
    maxAllowedTickets: maxAllowedTickets,
  );

  AppLogger.info(logger, 'Final cartItems: ${result['cartItems']}');
  AppLogger.info(
    logger,
    'Final additionOrder length: ${result['additionOrder'].length}',
  );
  AppLogger.info(
    logger,
    'Last 10 items in final additionOrder: ${result['additionOrder'].skip(result['additionOrder'].length - 10).toList()}',
  );
}
