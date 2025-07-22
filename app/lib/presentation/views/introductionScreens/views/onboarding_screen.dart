import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/introductionScreens/models/onboarding_page_data.dart';
import 'package:app/presentation/app_main.dart';
import 'package:app/main.dart';
import 'package:app/presentation/views/loginPage/login_page.dart';
import 'package:app/presentation/views/loginPage/registration_page.dart';
import 'package:app/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:logging/logging.dart';
import 'package:easy_localization/easy_localization.dart';

/// Onboarding screen with 3 pages using introduction_screen package
/// Appears after splash screen and navigates to home page
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  final GlobalKey<IntroductionScreenState> _introKey =
      GlobalKey<IntroductionScreenState>();

  // Logger for this class
  static final Logger _logger = AppLogger.getLogger('OnboardingScreen');

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
        child: Stack(
          children: [
            IntroductionScreen(
              key: _introKey,
              pages: _buildPages(context),
              onDone: () => _onFinish(context),
              onSkip: () => _skipToLastPage(),
              onChange: (page) => setState(() => _currentPage = page),
              showSkipButton: _currentPage < 2,
              showNextButton: _currentPage < 2,
              showDoneButton: false,
              skipOrBackFlex: 0,
              nextFlex: 0,
              scrollPhysics: const ClampingScrollPhysics(),
              skip: Text(
                'skip'.tr(),
                style: TextStyle(
                  color: kPinkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              next: Icon(Icons.arrow_forward, color: kPinkColor),
              curve: Curves.easeInOut,
              controlsMargin: const EdgeInsets.all(16),
              controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
              dotsDecorator: DotsDecorator(
                size: const Size(0, 0),
                color: Colors.transparent,
                activeSize: const Size(0, 0),
                activeColor: Colors.transparent,
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              globalBackgroundColor: Colors.transparent,
            ),
            // Custom dots
            _buildCustomDots(),
          ],
        ),
      ),
    );
  }

  /// Build custom dots widget
  Widget _buildCustomDots() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            bool isActive = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: isActive ? 22.0 : 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: isActive ? kPinkColor : Colors.grey[400]!,
                borderRadius: BorderRadius.circular(25.0),
              ),
            );
          }),
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
              const SizedBox(height: 40),
              // Centered image from assets/images/IntroductionScreen
              SizedBox(
                height: 280,
                width: 280,
                child: Image.asset(pageData.imagePath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 30),
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
        bodyWidget: isLastPage
            ? _buildThirdPageButtons(context)
            : const SizedBox.shrink(),
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
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sign up button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to RegistrationPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPinkColor,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: kPinkColor.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                'sign_up'.tr(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // "Already have an account? Sign in" text
          TextButton(
            onPressed: () {
              // Debug logger for sign in navigation
              AppLogger.debug(
                _logger,
                'Sign in button pressed from onboarding screen',
              );
              AppLogger.debug(_logger, 'Navigating to LoginPage...');

              // Navigate to LoginPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              ).then((result) {
                // Log when returning from login page
                AppLogger.debug(
                  _logger,
                  'Returned from LoginPage with result: $result',
                );
              });
            },
            child: RichText(
              text: TextSpan(
                text: '${'already_have_account'.tr()} ',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
                children: [
                  TextSpan(
                    text: 'sign_in'.tr(),
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

          const SizedBox(height: 10),

          // "or" text only
          Text(
            'or'.tr(),
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          // Continue as Guest button
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: () {
                // Navigate to main app as guest user
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppMain(key: appMainKey),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[300],
                side: BorderSide(color: Colors.grey[600]!, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 18, color: Colors.grey[300]),
                  const SizedBox(width: 8),
                  Text(
                    'continue_as_guest'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Skip to the last introduction screen page
  void _skipToLastPage() {
    _introKey.currentState?.animateScroll(2);
  }

  /// Navigate to main app with tab bar when onboarding is completed
  /// TODO: Replace navigation to AppMain with LoginPage
  void _onFinish(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AppMain(key: appMainKey)),
    );
  }
}
