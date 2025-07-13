import 'package:app/presentation/app_main.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
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

    // Naviga a AppMain() al termine del fade-out
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppMain()),
          //TODO: modificare con LoginPage() quando sarà implementata
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
