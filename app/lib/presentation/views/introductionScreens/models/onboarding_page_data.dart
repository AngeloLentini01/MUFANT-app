import 'package:easy_localization/easy_localization.dart';

class OnboardingPageData {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

/// Provider for onboarding page data
/// Easy to modify texts, image paths, and add more pages
class OnboardingDataProvider {
  static List<OnboardingPageData> get pages => [
    // Page 1: Community and Events
    OnboardingPageData(
      imagePath:
          'assets/images/IntroductionScreen/robot_introduction_screen_1.png',
      title: 'onboarding_page1_title'.tr(),
      description: 'onboarding_page1_description'.tr(),
    ),

    // Page 2: Digital Ticketing
    OnboardingPageData(
      imagePath:
          'assets/images/IntroductionScreen/robot_introduction_screen_2.png',
      title: 'onboarding_page2_title'.tr(),
      description: 'onboarding_page2_description'.tr(),
    ),

    // Page 3: Call to Action
    OnboardingPageData(
      imagePath:
          'assets/images/IntroductionScreen/robot_introduction_screen_3.png',
      title: 'onboarding_page3_title'.tr(),
      description: '', // Empty description to save space for buttons
    ),
  ];
}
