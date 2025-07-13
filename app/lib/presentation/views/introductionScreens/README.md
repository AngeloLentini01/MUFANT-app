# Onboarding Introduction Screens

This module implements a 3-page onboarding flow using the `introduction_screen` package (^3.1.17) that appears immediately after the splash screen.

## Flow Structure

```
SplashScreen → OnboardingScreen (3 pages) → AppMain (with TabBar)
```

## Features

### 🎨 Design Elements
- **Consistent Colors**: Uses project's color scheme (kPinkColor, kBlackColor)
- **Gradient Background**: Same LinearGradient as Home and Profile pages (kBlackColor → Colors.grey[900])
- **Modern UI**: Clean, minimalist design matching the app's aesthetic
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Uses introduction_screen's built-in transitions

### 📱 Three Onboarding Pages

1. **Page 1**: "Stay connected to geek communities and events"
   - Robot image: `robot_introduction_screen_1.png`
   - Community and events focus

2. **Page 2**: "Buy your ticket in a click"  
   - Robot image: `robot_introduction_screen_2.png`
   - Digital ticketing features

3. **Page 3**: "The future is in your hands. Join us today."
   - Robot image: `robot_introduction_screen_3.png` 
   - Call to action with login option

### 🎛️ Controls

- **Skip Button**: Available on all pages, jumps directly to AppMain (with TabBar)
- **Next Button**: On pages 1-2, advances to next page
- **Done Button**: On page 3, completes onboarding flow

## File Structure

```
introductionScreens/
├── introduction_screens.dart          # Export file
├── models/
│   └── onboarding_page_data.dart     # Data model for page content
└── views/
    └── onboarding_screen.dart        # Main onboarding widget
```

## Assets Required

Ensure these images exist in `assets/images/IntroductionScreen/`:
- `robot_introduction_screen_1.png`
- `robot_introduction_screen_2.png`  
- `robot_introduction_screen_3.png`

## Usage

The onboarding automatically appears after the splash screen. No manual initialization needed.

### Importing
```dart
import 'package:app/presentation/views/introductionScreens/views/onboarding_screen.dart';
```

### Navigation Flow
1. App starts → `SplashScreen`
2. After 2.2s fade → `OnboardingScreen` 
3. User completes/skips → `AppMain` (with TabBar showing Home, Shop, Profile)

## Customization

### Modifying Content
Edit `OnboardingDataProvider` in `onboarding_page_data.dart`:
```dart
OnboardingPageData(
  imagePath: 'assets/images/IntroductionScreen/your_image.png',
  title: 'Your Custom Title',
  description: 'Your custom description text.',
)
```

### Changing Final Navigation
Update the TODO in `onboarding_screen.dart`:
```dart
// TODO: Replace navigation to AppMain with LoginPage
void _onFinish(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()), // Change this
  );
}
```

### Styling
Colors and spacing can be adjusted in the `_buildPages()` method of `OnboardingScreen`.

## Dependencies

- `introduction_screen: ^3.1.17` - Main onboarding package
- Project color constants from `colors/generic.dart`
- Robot images from `assets/images/IntroductionScreen/`

## TODO Items

- [ ] Implement proper login navigation (currently shows snackbar)
- [ ] Add user preference to skip onboarding on subsequent app launches
- [ ] Consider adding analytics tracking for onboarding completion
- [ ] Implement A/B testing for different onboarding content
