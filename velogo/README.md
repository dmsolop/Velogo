# Velogo

A Flutter application for cycling route planning and tracking with Clean Architecture.

## Architecture

This project follows Clean Architecture principles with Feature-first organization:

- **Domain Layer** - Business logic, entities, and use cases
- **Data Layer** - Data sources, models, and repository implementations
- **Presentation Layer** - UI components, BLoCs, and pages

## Features

- ✅ **Auth Feature** - User authentication and registration
- ✅ **Map Feature** - Route planning and tracking
- ✅ **Weather Feature** - Weather information for routes
- ✅ **Navigation Feature** - App navigation and theme management
- ✅ **Profile Feature** - User profile management
- 🔄 **Settings Feature** - App settings (in progress)

## Firebase Configuration

### Security Rules

Firebase Firestore security rules are configured to ensure data protection:

- Users can only access their own data
- Authentication is required for all operations
- Default deny policy for unknown collections

See [FIREBASE_SECURITY.md](FIREBASE_SECURITY.md) for detailed security configuration.

### Collections

- `users/{userId}` - User authentication data
- `profiles/{userId}` - User profile information
- `routes/{routeId}` - Cycling routes (planned)
- `settings/{userId}` - User settings (planned)

## Getting Started

### Prerequisites

- Flutter SDK
- Firebase CLI
- Android Studio / VS Code

### Setup

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Configure Firebase: `firebase init`
4. Deploy security rules: `firebase deploy --only firestore:rules`
5. Run the app: `flutter run`

### Development

- **Code Generation**: `flutter packages pub run build_runner build`
- **Testing**: `flutter test`
- **Analysis**: `flutter analyze`

## Security

All Firebase operations are protected by security rules. Users can only access their own data, and all operations require authentication.

For detailed security configuration, see [FIREBASE_SECURITY.md](FIREBASE_SECURITY.md).

## Contributing

1. Follow Clean Architecture principles
2. Use Feature-first organization
3. Implement proper error handling with Either
4. Write tests for new features
5. Update documentation

## License

This project is licensed under the MIT License.
