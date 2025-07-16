import 'package:app/presentation/styles/all.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/presentation/views/checkout/payment_processing_page.dart';
import 'package:app/model/items/ticket/ticket_display_data.dart';
import 'package:app/model/items/ticket/ticket_model.dart';
import 'package:app/model/museum/activity/museum_activity_model.dart';
import 'package:app/data/services/ticket_service.dart';
import 'package:app/model/cart/cart_model.dart';
import 'package:app/utils/app_logger.dart';
import 'package:logging/logging.dart';

class CheckoutPage extends StatefulWidget {
  final CartModel cart;
  final List<MuseumActivityModel> availableActivities;
  const CheckoutPage({
    super.key,
    required this.cart,
    required this.availableActivities,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class PaymentType extends StatelessWidget {
  const PaymentType({
    super.key,
    required this.asset,
    required this.name,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final String name;
  final String asset;
  final String groupValue;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const colorRadiosSelector = Color.fromARGB(204, 154, 147, 186);

    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kPinkColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: paddingCardOption,
          child: Row(
            children: [
              SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  8,
                ), // Adjust for more/less rounding
                child: Image.asset(
                  asset,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              startTextDistance,
              SizedBox(width: 100, child: Text(name)),
              textRadioDistance,
              Radio<String>(
                //TODO: change color of unselected widget to change radio unselected button color on the theme
                focusColor: colorRadiosSelector,
                activeColor: colorRadiosSelector,
                hoverColor: colorRadiosSelector,
                value: value,
                groupValue: groupValue,
                onChanged: (String? newValue) {
                  onChanged(newValue!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutPageState extends State<CheckoutPage> {
  String isChecked = "";
  final _cardNumberController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _cvvController = TextEditingController();
  String? _cardNumberError;
  String? _dueDateError;
  String? _cvvError;
  bool _showValidationError = false;
  static final Logger _logger = AppLogger.getLogger('CheckoutPage');

  @override
  void dispose() {
    _cardNumberController.dispose();
    _dueDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  bool get _isMasterCardValid {
    final cardNumber = _cardNumberController.text.trim();
    final dueDate = _dueDateController.text.trim();
    final cvv = _cvvController.text.trim();
    final cardNumberReg = RegExp(r'^[0-9]{16}\$');
    final dueDateReg = RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})$');
    final cvvReg = RegExp(r'^[0-9]{3,4}\$');
    _cardNumberError = cardNumberReg.hasMatch(cardNumber)
        ? null
        : 'card_number_error'.tr();
    _dueDateError = dueDateReg.hasMatch(dueDate) ? null : 'due_date_error'.tr();
    _cvvError = cvvReg.hasMatch(cvv) ? null : "cvv_error".tr();
    return _cardNumberError == null &&
        _dueDateError == null &&
        _cvvError == null;
  }

  bool get _isPayEnabled {
    if (isChecked.isEmpty) return false;
    if (isChecked == 'Master Card') {
      return _isMasterCardValid;
    }
    return true;
  }

  Future<void> _handlePayNow() async {
    if (!_isPayEnabled) {
      setState(() {
        _showValidationError = true;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cannot proceed'),
          content: const Text(
            'Please select a payment method and fill all required fields correctly.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Add all tickets from the cart to the user's tickets
    final now = DateTime.now();
    AppLogger.info(
      _logger,
      'Starting payment process with ${widget.cart.cartItems.length} items in cart',
    );

    try {
      for (final cartItem in widget.cart.cartItems) {
        AppLogger.info(
          _logger,
          'Processing cart item: ${cartItem.runtimeType}',
        );
        if (cartItem is TicketModel) {
          final ticket = TicketDisplayData(
            ticketModel: cartItem,
            purchaseDate: now,
            isExpired: false,
          );

          // Handle database read-only mode gracefully
          try {
            await TicketService().addTicket(ticket);
            AppLogger.info(
              _logger,
              'Added ticket to database: '
              'Event: "${cartItem.details.name}", '
              'Museum Activity: "${cartItem.museumActivity.details.name}", '
              'Date: "${cartItem.museumActivity.activeTimePeriod.start}", '
              'Price: "${cartItem.price}", '
              'Charging Rate: "${cartItem.chargingRate}"',
            );
          } catch (dbError) {
            AppLogger.warning(
              _logger,
              'Database is read-only, ticket not saved but payment continues: $dbError',
            );
            // Continue with payment even if database is read-only
          }
        } else {
          AppLogger.warning(
            _logger,
            'Cart item is not a TicketModel: ${cartItem.runtimeType}',
          );
        }
      }

      // Verify tickets were added (only if database is not read-only)
      try {
        final ticketService = TicketService();
        await ticketService.ready;
        final allTickets = ticketService.getAllTickets();
        AppLogger.info(
          _logger,
          'After adding tickets, total tickets in database: ${allTickets.length}',
        );
      } catch (dbError) {
        AppLogger.warning(
          _logger,
          'Could not verify tickets due to database read-only mode: $dbError',
        );
      }
    } catch (e, stack) {
      AppLogger.error(_logger, 'Error processing payment', e, stack);
      // Show error to user but don't block payment flow
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment processed but there was an issue saving tickets. Please contact support.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }

    // Optionally clear the cart here (if you have a cart service, call its clear method)
    // Example: CartService().clear();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PaymentProcessingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      appBar: AppBar(
        backgroundColor: kBlackColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: kWhiteColor, size: 24),
        ),
        title: Text("shop".tr(), style: TextStyle(color: kWhiteColor)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "payment_title".tr(),
                style: TextStyle(color: kPinkColor, fontSize: 28, height: 1.2),
              ),
              kSpaceBetweenSections,
              PaymentType(
                asset: "assets/images/payment_icon/paypal_logo.png",
                name: "paypal".tr(),
                groupValue: isChecked,
                value: "Paypal",
                onChanged: (String newValue) {
                  setState(() {
                    isChecked = newValue;
                    _showValidationError = false;
                  });
                },
              ),
              kSpaceBetweenSections,
              PaymentType(
                asset: "assets/images/payment_icon/mastercard_logo.png",
                name: "master_card".tr(),
                groupValue: isChecked,
                value: "Master Card",
                onChanged: (String newValue) {
                  setState(() {
                    isChecked = newValue;
                    _showValidationError = false;
                  });
                },
              ),
              if (isChecked == "Master Card")
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kPinkColor),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            labelText: "card_number".tr(),
                            border: OutlineInputBorder(),
                            errorText:
                                _showValidationError && _cardNumberError != null
                                ? _cardNumberError
                                : null,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            if (_showValidationError) setState(() {});
                          },
                        ),
                        if (_showValidationError && _cardNumberError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              _cardNumberError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        cardOtherDistance,
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _dueDateController,
                                decoration: InputDecoration(
                                  labelText: "due_date".tr(),
                                  hintText: "MM/YY",
                                  border: OutlineInputBorder(),
                                  errorText:
                                      _showValidationError &&
                                          _dueDateError != null
                                      ? _dueDateError
                                      : null,
                                ),
                                keyboardType: TextInputType.datetime,
                                onChanged: (_) {
                                  if (_showValidationError) setState(() {});
                                },
                              ),
                            ),
                            dateCvvDistance,
                            Expanded(
                              child: TextField(
                                controller: _cvvController,
                                decoration: InputDecoration(
                                  labelText: "cvv".tr(),
                                  border: OutlineInputBorder(),
                                  errorText:
                                      _showValidationError && _cvvError != null
                                      ? _cvvError
                                      : null,
                                ),
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                onChanged: (_) {
                                  if (_showValidationError) setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                        if (_showValidationError &&
                            (_dueDateError != null || _cvvError != null))
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              children: [
                                if (_dueDateError != null)
                                  Text(
                                    _dueDateError!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                if (_cvvError != null)
                                  Text(
                                    _cvvError!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              kSpaceBetweenSections,
              PaymentType(
                asset: "assets/images/payment_icon/apple_pay_logo.png",
                name: "Apple Pay",
                groupValue: isChecked,
                value: "Apple Pay",
                onChanged: (String newValue) {
                  setState(() {
                    isChecked = newValue;
                    _showValidationError = false;
                  });
                },
              ),
              kSpaceBetweenSections,
              PaymentType(
                asset: "assets/images/payment_icon/google_pay_logo.jpg",
                name: "Google Pay",
                groupValue: isChecked,
                value: "Google Pay",
                onChanged: (String newValue) {
                  setState(() {
                    isChecked = newValue;
                    _showValidationError = false;
                  });
                },
              ),
              kSpaceBetweenSections,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPayEnabled ? kPinkColor : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _isPayEnabled ? _handlePayNow : _handlePayNow,
                  child: Text(
                    "pay_now".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar removed to hide the tab bar on checkout page
    );
  }
}
