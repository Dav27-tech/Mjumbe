# LUMA NEWS

![Flutter](https://img.shields.io/badge/Flutter-3.35.x-02569B?logo=flutter) ![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart) ![CI](https://img.shields.io/badge/CI-GitHub_Actions-2088FF?logo=githubactions) ![Tests](https://img.shields.io/badge/Tests-Flutter_Test-4EAA25?logo=flutter) ![License](https://img.shields.io/badge/License-MIT-green.svg)

LUMA NEWS is a Flutter news application built around a clean architecture and a modern mobile-first user experience. The app integrates Firebase Authentication, NewsAPI, local bookmarking, offline state handling, and a responsive navigation shell.

## Description

LUMA NEWS provides a simplified news-reading experience with:

- a top headlines feed
- category-based browsing
- article detail view
- authentication flow with Firebase
- bookmarked articles persisted locally
- offline awareness and graceful fallbacks
- French and English localization

The project is structured to separate domain logic, data sources, and presentation while preserving a clear dependency flow with GetIt and BLoC.

## Features

- Authentication with Firebase Auth
- News feed powered by NewsAPI
- Search and refresh support for headlines
- Article details with external link access
- Bookmark saving with Hive persistence
- Offline status banner when the connection is lost
- Three-tab navigation: Home, Bookmarks, Profile
- French and English supported locales
- Dark-light theme styling with a material-based UI
- CI pipeline configured with GitHub Actions

## Screenshots

No screenshots are currently included in this repository.

## Architecture

The application follows a layered structure:

- Domain: entities, repositories, and use cases
- Data: remote API sources, Firebase auth repository, Hive local storage
- Presentation: BLoC-based state management and page widgets
- Routing: GoRouter with auth redirection
- DI: GetIt central container

Key technologies used in the project:

- Flutter
- Dart
- flutter_bloc
- go_router
- get_it
- dio
- firebase_core
- firebase_auth
- cloud_firestore
- hive + hive_flutter
- flutter_secure_storage
- cached_network_image
- flutter_localizations + intl
- url_launcher

## Project Structure

```text
.
├── .github/
│   └── workflows/
│       └── flutter.yml
├── android/
├── ios/
├── lib/
│   ├── app/
│   ├── core/
│   ├── features/
│   ├── l10n/
│   ├── injection_container.dart
│   ├── main.dart
│   └── ...
├── test/
├── integration_test/
├── .env
├── .env.example
├── analysis_options.yaml
├── CHANGELOG.md
├── LICENSE
├── pubspec.yaml
├── README.md
└── l10n.yaml
```

## Technologies

- Flutter SDK: 3.35.x
- Dart SDK: >=3.0.0 <4.0.0
- Firebase Auth and Firebase Core
- NewsAPI integration via Dio
- Hive for persistent local bookmarks
- BLoC for state management
- GoRouter for navigation
- Material Design app theme
- Localizations with generated ARB files

## Installation

1. Clone the project:

```bash
git clone https://github.com/Dav27-tech/mjumbe
cd mjumbe
```

2. Install dependencies:

```bash
flutter pub get
```

3. Generate localization files if needed:

```bash
flutter gen-l10n
```

4. Run the application:

```bash
flutter run
```

## Configuration

Create a local environment file based on the example file:

```bash
cp .env.example .env
```

Then fill in the required values before running the app.

## Firebase Setup

The project uses Firebase for authentication.

For web builds, the app reads Firebase values from the environment file, including:

- FIREBASE_API_KEY
- FIREBASE_APP_ID
- FIREBASE_MESSAGING_SENDER_ID
- FIREBASE_PROJECT_ID
- FIREBASE_AUTH_DOMAIN
- FIREBASE_STORAGE_BUCKET
- FIREBASE_MEASUREMENT_ID

For mobile builds, the app initializes Firebase using the native Firebase configuration already present in the platform setup.

## NewsAPI Setup

The app expects the following variables in `.env`:

```env
NEWS_API_KEY=votre_cle_api_newsapi_ici
NEWS_API_BASE_URL=https://newsapi.org/v2
```

The API key is read at runtime via `flutter_dotenv` and used by the remote news data source.

## Testing

The repository includes unit tests and widget tests as well as integration tests.

Run the test suite with:

```bash
flutter test
```

For integration tests:

```bash
flutter test integration_test
```

## CI/CD

A GitHub Actions workflow is configured in:

- [.github/workflows/flutter.yml](.github/workflows/flutter.yml)

The pipeline runs:

- `flutter pub get`
- `flutter analyze`
- `flutter test`

## Performance

Performance-oriented choices include:

- cached network images for article thumbnails
- lazy list rendering for news content
- local bookmark storage to avoid unnecessary API calls
- offline banner and reliability guardrails for connectivity issues

## Accessibility

The application includes accessibility-oriented improvements such as:

- semantic labels on key interactive elements
- text-based labels for navigation and actions
- clear focus-friendly UI structure
- readable contrast-based theming

## Internationalization

LUMA NEWS supports multilingual UI text through Flutter localization.

Available locales include:

- English
- French

Generated localization files are located in the `lib/l10n` directory.

## Security

Security measures in the project include:

- environment-based secrets in `.env`
- Firebase auth token handling through configured repositories and interceptors
- secure local storage for sensitive data via `flutter_secure_storage`
- no secrets committed to the Git repository

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for the project version history.

## Contribution

Contributions are welcome. Please keep changes focused, documented, and aligned with the existing architecture.

## Author

AMANI MUSAFIRI David

## License

This project is released under the MIT License. See [LICENSE](LICENSE) for details.
