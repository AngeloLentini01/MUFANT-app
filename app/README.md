# MUFANT App - Technical Documentation
## 📱 Overview
MUFANT is a Flutter-based mobile application designed for museum visitors, providing digital ticketing, event management, community features, and interactive museum experiences. The app supports both English and Italian languages and offers a modern, dark-themed UI with smooth animations.
## 🏗️ Architecture
### Project Structure
app/
├── lib/
│   ├── data/                    # Data layer
│   │   ├── dbManagers/         # Database managers
│   │   ├── services/           # Business logic services
│   │   └── mufant_museum.db   # SQLite database
│   ├── model/                  # Data models
│   │   ├── cart/              # Shopping cart models
│   │   ├── community/         # Chat and community models
│   │   ├── database/          # Database entity models
│   │   ├── generic/           # Generic base models
│   │   ├── items/             # Product and item models
│   │   └── museum/            # Museum-specific models
│   ├── presentation/          # UI layer
│   │   ├── app_main.dart     # Main app widget
│   │   ├── app_pre_configurator.dart
│   │   ├── models/           # UI-specific models
│   │   ├── services/         # UI services
│   │   ├── styles/           # Styling and theming
│   │   ├── theme/            # Theme configuration
│   │   ├── views/            # Screen widgets
│   │   └── widgets/          # Reusable UI components
│   ├── utils/                # Utility functions
│   └── main.dart             # App entry point
├── assets/                   # Static assets
├── test/                     # Test files
└── scripts/                  # Build and migration scripts
## Technology Stack
Framework: Flutter 30.81Language: Dart
Database: SQLite (sqflite)
State Management: Built-in Flutter state management
Localization: Easy Localization
UI Components: Material Design with custom theming
Testing: Flutter Test + Mockito
## 🚀 Features
Core Features1*Digital Ticketing System**
Museum ticket purchases
Event ticket management
Barcode generation and scanning
Ticket validation and expiration
Event Management
Museum events listing
Event details and descriptions
Room and activity information
Interactive event maps
Community Features
Community chat system
User profiles and badges
Achievement system
Social interactions
Shopping & Payment
E-commerce functionality
Shopping cart management
Multiple payment methods
Order tracking
User Management
User registration and login
Profile management
Session management
Badge and achievement tracking
Technical Features
Multi-language Support: English and Italian
Offline Capability: Local SQLite database
Content Filtering: Bad words filter with whitelist
Responsive Design: Adaptive UI for different screen sizes
Smooth Animations: Custom tab bar animations
Data Migration: Automatic database schema updates
## 🛠️ Setup & Installation
Prerequisites
Flutter SDK3.81 higher
Dart SDK
Android Studio / VS Code
Git
Installation Steps
Clone the repository
git clone <repository-url>
cd app
Install dependencies
flutter pub get

```3. **Run the app**
```bash
flutter run
Database Setup
The app automatically handles database initialization and migrations:
Database file: mufant_museum.db
Schema version: 8
Automatic migration from old schemas
Sample data initialization
📦 Dependencies
Core Dependencies
# Database & Storage
sqflite: ^2.4.2
shared_preferences: ^2.5.3I & Styling
google_fonts: ^60.1.0
skeletonizer: ^2.00.1
flutter_staggered_animations: ^1.1.1 Localization
easy_localization: ^3.00.7+1

# Utilities
ulid: ^2.0.0ey2: ^6.00.2to: ^3.00.6
logging: ^10.3# Features
barcode: ^2.20.9
barcode_widget: ^2.0.4ticket_material: ^03.1ntroduction_screen: ^3.1.17
Development Dependencies
flutter_test: sdk: flutter
mockito: ^50.4.4
build_runner: ^2.4.8er: ^2.10
flutter_lints: ^6.00## 🎨 UI/UX Design

### Design System
- **Primary Colors**: Black (`#00000`) and Pink (`#FF7CA3
- **Typography**: Google Fonts (Exo 2)
- **Theme**: Dark theme with custom color scheme
- **Animations**: Smooth transitions and micro-interactions

### Key UI Components
1. **Custom Tab Bar**: Animated bottom navigation with smooth transitions
2**Splash Screen**: Branded loading screen with fade animations3*Introduction Screens**:3ge onboarding flow
4. **Responsive Layouts**: Adaptive design for different screen sizes

## 🔧 Configuration

### Environment Setup
1. **Database Configuration**: Automatic in `lib/main.dart`2 **Localization**: Configured in `main()` function
3. **Logging**: Initialized via `AppLogger.init()`
4. **Bad Words Filter**: Whitelist and sensitivity settings

### Build Configuration
- **Android**: Configured in `android/app/build.gradle.kts`
- **iOS**: Configured in `ios/Runner/Info.plist`
- **Icons**: Generated via `flutter_launcher_icons.yaml`

## 🧪 Testing

### Test Structure
test/ ├── model/ # Model tests ├── models/ # UI model tests ├── tabBarPages/ # Page-specific tests └── ticket_service_test.dart # Service tests

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/ticket_service_test.dart

# Run with coverage
flutter test --coverage
📱 App Flow
Navigation Structure
SplashScreen
    ↓
OnboardingScreen (3ges)
    ↓
AppMain (TabBar)
├── HomePage
├── ShopPage
└── ProfilePage
Key Screens
1Splash Screen: App initialization and branding 2oarding**: Feature introduction for new users 3. Home: Events, activities, and community content 4. Shop: Ticket purchasing and e-commerce 5. Profile: User management and settings
🔒 Security Features
Content Filtering
Bad Words Filter: Real-time content filtering
Whitelist System: Prevents false positives
Fuzzy Matching: Typo-resistant detection
Multi-language Support: Italian and English filtering
Data Protection
Password Hashing: SHA-256yption
Session Management: Secure user sessions
Database Security: SQLite with proper access controls
🚀 Performance Optimizations
Database
Lazy Loading: Database initialization in background
Connection Pooling: Efficient database connections
Migration System: Automatic schema updates
UI Performance
Widget Rebuilding: Optimized with UniqueKey
Animation Controllers: Proper disposal and management
Image Caching: Efficient asset loading
🔄 Data Migration
Migration System
Automatic Detection: Version-based migration triggers
Data Preservation: Safe migration of existing data
Rollback Support: Database version management
Migration Scripts
complete_migration.ps1: PowerShell migration script
check_database_status.py: Database health checks
check_db_schema.py: Schema validation
🐛 Debugging & Logging
Logging System
Structured Logging: Using logging package
App Logger: Centralized logging utility
Error Tracking: Comprehensive error handling
Debug Tools
Flutter Inspector: UI debugging
Database Inspector: SQLite debugging
Performance Profiler: App performance monitoring
📋 Development Guidelines
Code Style
Dart Conventions: Follow official Dart style guide
Flutter Lints: Enabled via flutter_lints
Documentation: Comprehensive code comments
Best Practices
1ration of Concerns**: Clear layer separation 2. Error Handling: Comprehensive try-catch blocks 3. Resource Management: Proper disposal of controllers 4. Testing: Unit tests for critical functionality
Git Workflow
Feature Branches: Develop new features in separate branches
Pull Requests: Code review process
Commit Messages: Descriptive commit messages
🔮 Future Enhancements
Planned Features
[ ] Push notifications
[ ] Biometric authentication
[ ] Offline mode improvements
[ ] Advanced analytics
[ ] Social media integration
Technical Improvements
[ ] State management migration (Provider/Bloc)
[ ] API integration for real-time data
[ ] Enhanced caching strategies
[ ] Performance monitoring
📞 Support & Contributing
Getting Help
Check existing issues in the repository
Review the code documentation
Contact the development team
Contributing
Fork the repository
Create a feature branch
Make your changes
Add tests for new functionality
Submit a pull request
## 📄 License
This project is proprietary software. All rights reserved.

Version: 1.0.0+1 Last Updated: 2024
Flutter Version: 3.8.1+
Dart Version: 3.8.1+
