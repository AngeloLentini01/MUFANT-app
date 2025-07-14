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
      title: 'Stay connected to geek communities and events',
      description:
          'Join fellow enthusiasts and never miss an exciting event in the geek universe.',
    ),

    // Page 2: Digital Ticketing
    OnboardingPageData(
      imagePath:
          'assets/images/IntroductionScreen/robot_introduction_screen_2.png',
      title: 'Buy your ticket in a click',
      description:
          'Quick and secure digital ticketing for all your favorite events and experiences.',
    ),

    // Page 3: Call to Action
    OnboardingPageData(
      imagePath:
          'assets/images/IntroductionScreen/robot_introduction_screen_3.png',
      title: 'The future is in your hands',
      description: '', // Empty description to save space for buttons
    ),
  ];
}
