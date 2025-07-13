import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/introductionScreens/models/onboarding_page_data.dart';
import 'package:app/presentation/app_main.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

/// Onboarding screen with 3 pages using introduction_screen package
/// Appears after splash screen and navigates to home page
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
        ),
        child: IntroductionScreen(
          pages: _buildPages(context),
          onDone: () => _onFinish(context),
          onSkip: () => _onFinish(context),
          onChange: (page) => setState(() => _currentPage = page),
          showSkipButton: _currentPage < 2, // Only show Skip on pages 1-2
          showNextButton: _currentPage < 2, // Only show Next on pages 1-2 
          showDoneButton: _currentPage < 2, // Only show Done on pages 1-2
          skipOrBackFlex: 0,
          nextFlex: 0,
          skip: Text(
            'Skip',
            style: TextStyle(color: kPinkColor, fontWeight: FontWeight.w600),
          ),
          next: Icon(Icons.arrow_forward, color: kPinkColor),
          done: Text(
            'Done',
            style: TextStyle(color: kPinkColor, fontWeight: FontWeight.w600),
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
          globalBackgroundColor: Colors.transparent,
          // Remove custom footer to place buttons above dots
          // globalFooter: _currentPage == 2 ? _buildLastPageFooter(context) : null,
        ),
      ),
    );
  }

  /// Build the 3 onboarding pages
  /// Easy to modify image paths, titles, and descriptions
  List<PageViewModel> _buildPages(BuildContext context) {
    return OnboardingDataProvider.pages.asMap().entries.map((entry) {
      int index = entry.key;
      OnboardingPageData pageData = entry.value;
      bool isLastPage = index == 2; // Third page (index 2)
      
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
                child: Image.asset(pageData.imagePath, fit: BoxFit.contain),
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
              // Only show description if it's not empty (not the last page)
              if (pageData.description.isNotEmpty) ...[
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
            ],
          ),
        ),
        bodyWidget: isLastPage ? _buildThirdPageButtons(context) : const SizedBox.shrink(),
        decoration: PageDecoration(
          pageColor: Colors.transparent,
          imagePadding: EdgeInsets.zero,
          contentMargin: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          bodyPadding: EdgeInsets.zero,
        ),
      );
    }).toList();
  }

  /// Build buttons for the third page positioned above the navigation dots
  Widget _buildThirdPageButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sign up button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to RegistrationPage() after RegistrationPage is implemented
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Registration page not yet implemented'),
                    backgroundColor: kPinkColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPinkColor,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: kPinkColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // "Already have an account? Sign in" text
          TextButton(
            onPressed: () {
              // TODO: Navigate to LoginPage() after LoginPage is implemented
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Login page not yet implemented'),
                  backgroundColor: kPinkColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: RichText(
              text: TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(
                      color: kPinkColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Dev button to skip login/register (for development purposes)
          TextButton(
            onPressed: () {
              // Navigate directly to main app for development
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AppMain()),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.developer_mode,
                  size: 16,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 8),
                Text(
                  'Skip (Dev Mode)',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
