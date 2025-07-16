import 'package:flutter/material.dart';
import 'package:app/presentation/styles/all.dart';
import 'package:app/main.dart' show appMainKey;
import 'package:app/presentation/views/tabBarPages/profilePage/ticketList/ticket_list_page.dart';
import 'package:easy_localization/easy_localization.dart';

class PaymentSuccessPage extends StatelessWidget {
  final VoidCallback? onGoHome;
  const PaymentSuccessPage({super.key, this.onGoHome});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kBlackColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.celebration, size: 80, color: kPinkColor),
                const SizedBox(height: 32),
                Text(
                  "payment_success".tr(),
                  style: const TextStyle(
                    color: kPinkColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPinkColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      // Pop to root (AppMain)
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // Switch to profile tab
                      await Future.delayed(const Duration(milliseconds: 100));
                      appMainKey.currentState?.setTab(2);
                      await Future.delayed(const Duration(milliseconds: 100));
                      // Push TicketListPage
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => const TicketListPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'View My Tickets',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'or',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kPinkColor, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // Use a post-frame callback to notify parent to switch tab
                      if (onGoHome != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          onGoHome!();
                        });
                      }
                    },
                    child: const Text(
                      'Go to the Shop page',
                      style: TextStyle(
                        color: kPinkColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
