import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app/presentation/styles/all.dart';
import 'package:app/presentation/views/checkout/payment_success_page.dart';
import 'package:app/main.dart';

class PaymentProcessingPage extends StatefulWidget {
  const PaymentProcessingPage({super.key});

  @override
  State<PaymentProcessingPage> createState() => _PaymentProcessingPageState();
}

class _PaymentProcessingPageState extends State<PaymentProcessingPage> {
  int secondsLeft = 5;
  Timer? _timer;

  void _goToHomeTabAfterPop() {
    // Find the nearest AppMain ancestor and set its tab to Home
    // This assumes AppMain is the root and will rebuild on setState
    // Use addPostFrameCallback to ensure navigation is done
    // First pop to root (AppMain), then switch tab
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = appMainKey.currentState;
      if (state != null) {
        state.setState(() {
          state.currentIndex = 0;
          state.homePageKey = UniqueKey();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft == 1) {
        timer.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                PaymentSuccessPage(onGoHome: _goToHomeTabAfterPop),
          ),
        );
      } else {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kBlackColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_clock, size: 80, color: kPinkColor),
              const SizedBox(height: 32),
              Text(
                'Processing payment... Please wait',
                style: const TextStyle(color: kPinkColor, fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                '$secondsLeft',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPinkColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    _timer?.cancel();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentSuccessPage(onGoHome: _goToHomeTabAfterPop),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // No bottomNavigationBar here: tab bar is hidden on this page
      ),
    );
  }
}
