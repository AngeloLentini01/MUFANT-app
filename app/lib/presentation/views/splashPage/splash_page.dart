import 'package:app/presentation/views/introductionScreens/views/onboarding_screen.dart';
import 'package:app/presentation/app_main.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/data/services/user_session_manager.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Avvia il fade-out 2.2 secondi dopo l'avvio
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) _controller.forward();
    });

    // Naviga all'OnboardingScreen al termine del fade-out
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _checkAuthenticationAndNavigate();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Check if user is logged in and navigate accordingly
  Future<void> _checkAuthenticationAndNavigate() async {
    if (!mounted) return;

    try {
      // Check if user is logged in
      final isLoggedIn = await UserSessionManager.isLoggedIn();

      if (!mounted) return;

      if (isLoggedIn) {
        // User is logged in, go directly to main app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppMain()),
        );
      } else {
        // User is not logged in, show onboarding screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } catch (e) {
      // If there's an error checking authentication, default to onboarding
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset('assets/images/logo.png', width: 250),
        ),
      ),
    );
  }
}
