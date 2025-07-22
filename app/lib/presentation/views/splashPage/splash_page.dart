import 'package:app/presentation/views/introductionScreens/views/onboarding_screen.dart';
import 'package:app/presentation/app_main.dart';
import 'package:app/main.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/data/services/user_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;
  static bool _didHotReload = false;

  SplashScreenState() {
    // Reset hot reload flag on hot restart (constructor is called on restart)
    _didHotReload = false;
  }

  @override
  void reassemble() {
    super.reassemble();
    // This method is called on hot reload
    _didHotReload = true;
  }

  @override
  void initState() {
    super.initState();

    // Only skip splash in debug mode AND on hot reload
    if (kDebugMode && _didHotReload) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAuthenticationAndNavigate();
      });
      return;
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));

    // Avvia il fade-out 2.2 secondi dopo l'avvio
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) _controller?.forward();
    });

    // Naviga all'OnboardingScreen al termine del fade-out
    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _checkAuthenticationAndNavigate();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// Check if user is logged in and navigate accordingly
  Future<void> _checkAuthenticationAndNavigate() async {
    if (!mounted) return;

    // On hot reload, always go directly to main app, skipping login/onboarding
    if (kDebugMode && _didHotReload) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppMain(key: appMainKey)),
      );
      return;
    }

    try {
      // Check if user is logged in
      final isLoggedIn = await UserSessionManager.isLoggedIn();

      if (!mounted) return;

      if (isLoggedIn) {
        // User is logged in, go directly to main app with global key
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppMain(key: appMainKey)),
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
    // In debug mode, show a minimal splash or skip entirely
    if (kDebugMode && _didHotReload) {
      return Scaffold(
        backgroundColor: kBlackColor,
        body: Center(child: Image.asset('assets/images/logo.png', width: 250)),
      );
    }

    return Scaffold(
      backgroundColor: kBlackColor,
      body: Center(
        child: _fadeAnimation != null
            ? FadeTransition(
                opacity: _fadeAnimation!,
                child: Image.asset('assets/images/logo.png', width: 250),
              )
            : Image.asset('assets/images/logo.png', width: 250),
      ),
    );
  }
}
