# MUFANT-app

A cross-platform Flutter application for the MUFANT museum, providing interactive features, ticketing, community chat, and educational content for visitors. The app supports Android, iOS, web, Windows, macOS, and Linux platforms.

## Features

- Museum activity booking and ticketing
- Community chat and events
- Educational content and audio guides
- User profiles and avatars
- Badge and achievement system
- Multilingual support (English, Italian)
- Modern UI with custom themes

## Project Structure

```text
lib/
  data/           # Database managers, services, and local DB
  model/          # Data models (cart, community, museum, items, etc.)
  presentation/   # UI, views, widgets, themes, and services
  utils/          # Utilities and helpers
assets/
  icons/          # App and login icons
  images/         # Avatars, badges, wallpapers, tickets, etc.
  translations/   # Localization files (en.json, it.json)
scripts/          # Database and migration scripts
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (usually included with Flutter)
- Android Studio/Xcode for mobile development
- Node.js (for some web features, optional)

### Installation

1. Clone the repository:

   ``` sh
   git clone <repo-url>
   cd MUFANT-app/app

   ```

2. Install dependencies:

   ```sh
   flutter pub get
   ```

3. (Optional) Set up platform-specific dependencies (see Flutter docs for [Android](https://docs.flutter.dev/development/platform-integration/android), [iOS](https://docs.flutter.dev/development/platform-integration/ios), [Web](https://docs.flutter.dev/development/platform-integration/web), etc.)

## Running the App

- **Android/iOS:**

  ```sh

  flutter run
  ```

- **Web:**

  ```sh
  flutter run -d chrome
  ```

- **Windows/macOS/Linux:**

  ```sh
  flutter run -d windows  # or macos/linux
  ```

## Scripts

- Database and migration scripts are in the `scripts/` directory:
  - `check_database_status.py`
  - `check_db_schema.py`
  - `complete_migration.ps1`
  - etc.

## Assets

- App icons, images, and translations are in the `assets/` directory.
- Update or add new assets as needed, and reference them in your Dart code.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
