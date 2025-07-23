# MUFANT-app
==================================================

Date: June 2025
Author: Angelo Lentini
Project Type: Mobile/Web Application

==================================================

1. EXECUTIVE SUMMARY
==================

1.1 Purpose
-----------
The MUFANT Museum mobile application is designed to enhance the museum experience for visitors by providing digital ticketing, interactive community features, event management, and gamified user engagement. The app serves as a comprehensive platform that bridges the gap between traditional museum visits and modern digital interaction.

1.2 Target Audience
------------------
- PRIMARY: Science fiction and fantasy enthusiasts
- SECONDARY: Families with children interested in interactive museum experiences
- TERTIARY: Museum visitors seeking digital-first experiences
- DEMOGRAPHICS: Ages 8-65, tech-savvy individuals, geek culture enthusiasts

1.3 Platform Support
-------------------
- Android - customer main request (smartphones and tablets)
- iOS (iPhone and iPad)
- Web (responsive web application)
- Cross-platform development using Flutter framework

1.4 Main Goals
-------------
- INCREASE ENGAGEMENT: Boost visitor interaction through gamification and community features
- SOLVE DIGITAL GAP: Modernize museum experience with digital ticketing and interactive content
- ENHANCE ACCESSIBILITY: Provide multi-language support and accessible design
- STREAMLINE OPERATIONS: Digitize ticket purchasing and event management processes
- BUILD COMMUNITY: Create a platform for science fiction and fantasy enthusiasts to connect

==================================================

2. FEATURE SET & PRIORITIZATION
==============================

2.1 Core Features (MVP - Already Implemented)
---------------------------------------------

MUST HAVE (Currently Implemented):
- User authentication system (registration/login)
- Digital ticketing system with barcode generation
- Museum ticket purchasing (various price tiers)
- Event browsing and ticket purchasing
- Guided tour booking system
- Shopping cart functionality with checkout process
- User profile management
- Badge/achievement system (4 badges: Space Pioneer, Galactic Speaker, Time Voyager, Identity Shifter)
- Multi-language support (English/Italian)
- SQLite database with automatic migration
- Dark theme UI with custom styling
- Bottom navigation with 3 main tabs (Home, Shop, Profile)

SHOULD HAVE (Currently Implemented):
- Community chat features
- Visitor's guide with museum information
- Settings page with language switching
- Wallpaper collection system
- Notification system
- Session management
- Password security with hashing
- Responsive design for different screen sizes

COULD HAVE (Currently Implemented):
- Onboarding introduction screens
- Splash screen with branding
- Avatar customization
- Ticket quantity management
- Event filtering and categorization
- Database migration system

2.2 Future Features (Planned Enhancements)
------------------------------------------

MUST HAVE (Future Development):
- QR code scanning for ticket validation
- Push notifications for events and updates
- Enhanced security with biometric authentication

SHOULD HAVE (Future Development):
- Audio guides featuring voices of characters from fantasy worlds
- Advanced gamification elements:
  * Mission system that unlocks exclusive wallpapers
  * Extended badge collection (10+ badges)
  * Achievement leaderboards
  * Social sharing capabilities
- Offline mode improvements
- Real-time event updates via API integration

COULD HAVE (Future Development):
- Augmented Reality (AR) features for exhibits
- Social media integration
- Advanced analytics and user behavior tracking
- Personalized content recommendations
- Interactive museum maps with indoor navigation

WON'T HAVE (Current Scope):
- Third-party social login (Facebook, Google) - infrastructure not ready
- Payment gateway integration - using simplified payment flow
- Real-time chat messaging - current community features sufficient
- Advanced content management system - static content approach chosen

==================================================

3. SITEMAP
==========

3.1 Current Application Structure (MVP Implementation)
------------------------------------------------------

APP ENTRY POINT
├── Splash Screen
│   └── App initialization and branding
│
├── Onboarding Flow (3 screens)
│   ├── Page 1: Community & Events Introduction
│   ├── Page 2: Digital Ticketing Features
│   └── Page 3: Call to Action & Registration
│
└── Main Application (Tab-based Navigation)
    │
    ├── HOME TAB
    │   ├── Welcome Section
    │   ├── Community Chat Section
    │   ├── Visitor's Guide Widget
    │   ├── Event Listings
    │   ├── Room Discovery
    │   └── Notifications Panel
    │
    ├── SHOP TAB
    │   ├── Category Filter (Museum/Events/Tours)
    │   ├── Museum Tickets
    │   │   ├── Full Price (€8.00)
    │   │   ├── Student/Senior Reduced (€7.00)
    │   │   ├── Disabled/Turin Card (€6.00)
    │   │   ├── Kids 4-10 (€5.00)
    │   │   └── Under 4/Museum Pass (Free)
    │   ├── Event Tickets
    │   │   ├── Star Wars Exhibition
    │   │   ├── Superhero Exhibition
    │   │   └── Dynamic Events from Database
    │   ├── Guided Tours
    │   │   ├── Group Tour (1-5 people) - €60
    │   │   ├── Adult Tours - €13 per person
    │   │   ├── Reduced Rate Tours - €11 per person
    │   │   └── Kids Tours - €11 per person
    │   ├── Shopping Cart
    │   ├── Cart Confirmation
    │   └── Checkout Process
    │       ├── Payment Method Selection
    │       ├── Customer Information
    │       └── Payment Success
    │
    └── PROFILE TAB
        ├── Authentication Flow
        │   ├── Login Page
        │   └── Registration Page
        ├── User Profile Dashboard
        │   ├── Avatar Section
        │   ├── My Tickets Section
        │   │   ├── Active Tickets
        │   │   ├── Expired Tickets
        │   │   └── Ticket Details Modal
        │   ├── My Badges Section
        │   │   ├── Badge Grid Display
        │   │   └── Badge Detail Modal
        │   └── Wallpaper Collection
        └── Settings
            ├── Language Selection (EN/IT)
            ├── Account Management
            └── App Information

3.2 Navigation Patterns
-----------------------
- Bottom Tab Navigation: Primary navigation method
- Stack Navigation: Within each tab for detailed views
- Modal Navigation: For overlays like badge details and settings
- Gesture Navigation: Swipe gestures for tab switching

3.3 External Design Resources
----------------------------
Figma Project Link: [Design specifications and wireframes available in project documentation]

==================================================

4. ACCESSIBILITY
===============

4.1 Current Accessibility Features (Implemented)
------------------------------------------------

LANGUAGE ACCESSIBILITY:
- Complete multi-language support (English/Italian)
- Dynamic language switching without app restart
- Localized content for all UI elements
- Cultural adaptation of pricing and museum information
- Easy Localization framework implementation

VISUAL ACCESSIBILITY:
- High contrast dark theme design
- Clear typography using Google Fonts (Montserrat, Exo 2)
- Consistent color scheme (Black #000000, Pink #FF7CA3)
- Readable font sizes with adequate spacing
- Icon-based navigation with text labels

INTERACTION ACCESSIBILITY:
- Touch-friendly interface design
- Intuitive navigation patterns
- Clear call-to-action buttons
- Consistent UI patterns throughout the app
- Error messages with clear instructions

4.2 Planned Accessibility Features (Future Development)
-------------------------------------------------------

VISUAL IMPAIRMENT SUPPORT:
- Adjustable text size functionality
- Screen reader compatibility (TalkBack/VoiceOver)
- Voice-over support for all interactive elements
- Alternative text for images and icons
- High contrast theme options

HEARING IMPAIRMENT SUPPORT:
- Visual notification indicators
- Vibration feedback for important alerts
- Subtitle support for audio content
- Sign language interpretation videos (for guided tours)

MOTOR IMPAIRMENT SUPPORT:
- Voice navigation commands
- Gesture customization options
- Switch navigation support
- Larger touch targets for easier interaction
- Simplified navigation modes

COGNITIVE ACCESSIBILITY:
- Simplified interface mode
- Step-by-step guided processes
- Clear progress indicators
- Consistent navigation patterns
- Error prevention and recovery

AUDIO ACCESSIBILITY (Priority Feature):
- Audio guides featuring voices of characters from fantasy worlds
- Character-specific narration (e.g., Gandalf for fantasy exhibits, Yoda for sci-fi sections)
- Multi-language audio support
- Adjustable playback speed
- Audio descriptions for visual content
- Offline audio content availability

4.3 Accessibility Testing & Compliance
--------------------------------------
- WCAG 2.1 AA compliance targeting
- Platform-specific accessibility testing (iOS/Android)
- User testing with accessibility needs
- Regular accessibility audits
- Community feedback integration for accessibility improvements

==================================================

TECHNICAL NOTES
==============

Development Framework: Flutter 3.8.1+
Database: SQLite with automatic schema migration
State Management: Built-in Flutter state management
Architecture: Clean architecture with separation of concerns
Testing: Unit tests and widget tests implemented
Performance: Optimized for smooth 60fps animations

==================================================

CONCLUSION
==========

The MUFANT Museum application represents a comprehensive digital solution for modern museum experiences, specifically tailored for science fiction and fantasy enthusiasts. The current MVP implementation provides a solid foundation with essential features for digital ticketing, community engagement, and user management.

The planned accessibility features, particularly the character-voiced audio guides and comprehensive multi-language support, position the app as an inclusive and innovative museum companion. The gamification elements and community features address the specific needs of the geek culture target audience while maintaining broad appeal for families and general museum visitors.

Future development phases will focus on enhancing accessibility, expanding gamification features, and implementing advanced technologies like QR code scanning and AR integration to create a truly immersive and accessible museum experience.

==================================================




