import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/introductionScreens/models/onboarding_page_data.dart';
import 'package:app/presentation/app_main.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

/// Onboarding screen with 3 pages using introduction_screen package
/// Appears after splash screen and navigates to home page
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: _buildPages(context),
        onDone: () => _onFinish(context),
        onSkip: () => _onFinish(context),
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        skip: Text(
          'Skip',
          style: TextStyle(
            color: kPinkColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        next: Icon(
          Icons.arrow_forward,
          color: kPinkColor,
        ),
        done: Text(
          'Done',
          style: TextStyle(
            color: kPinkColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        curve: Curves.easeInOut,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: DotsDecorator(
          size: const Size(10.0, 10.0),
          color: Colors.grey[400]!,
          activeSize: const Size(22.0, 10.0),
          activeColor: kPinkColor,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        globalBackgroundColor: kBlackColor,
      ),
    );
  }

  /// Build the 3 onboarding pages
  /// Easy to modify image paths, titles, and descriptions
  List<PageViewModel> _buildPages(BuildContext context) {
    return OnboardingDataProvider.pages.map((pageData) {
      return PageViewModel(
        titleWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Centered image from assets/images/IntroductionScreen
              Container(
                height: 300,
                width: 300,
                child: Image.asset(
                  pageData.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),
              // Short descriptive text below the image
              Text(
                pageData.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                pageData.description,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        bodyWidget: const SizedBox.shrink(), // Empty body since we use titleWidget
        decoration: PageDecoration(
          pageColor: kBlackColor,
          imagePadding: EdgeInsets.zero,
          contentMargin: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          bodyPadding: EdgeInsets.zero,
        ),
      );
    }).toList();
  }

  /// Navigate to main app with tab bar when onboarding is completed
  /// TODO: Replace navigation to AppMain with LoginPage
  void _onFinish(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AppMain()),
    );
  }
}
