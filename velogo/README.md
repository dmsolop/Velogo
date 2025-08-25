# Velogo

A Flutter application for cycling route planning and tracking with Clean Architecture.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **Feature-first** organization:

### **Layers:**
- **Domain Layer** - Business logic, entities, and use cases
- **Data Layer** - Data sources, models, and repository implementations  
- **Presentation Layer** - UI components, BLoCs, and pages

### **Key Technologies:**
- **flutter_bloc** - State management
- **dartz** - Functional programming (Either, Unit)
- **freezed** - Immutable data classes
- **get_it** - Dependency injection
- **Firebase** - Backend services (Auth, Firestore, Functions)

## ✅ Features Status

### **Completed Features:**
- ✅ **Auth Feature** - User authentication and registration with validation
- 🔄 **Map Feature** - Route planning and tracking (Clean Architecture migration in progress)
- ✅ **Weather Feature** - Weather information for routes
- ✅ **Navigation Feature** - App navigation and theme management
- ✅ **Profile Feature** - User profile management with Firebase integration
- 🔄 **Settings Feature** - App settings (in progress)

### **Testing Coverage:**
- ✅ **Unit Tests** - Auth Feature use cases (19 tests passing)
- 🔄 **Integration Tests** - In progress
- 🔄 **Widget Tests** - In progress

## 🔥 Firebase Configuration

### **Security Rules**
Firebase Firestore security rules are configured to ensure data protection:

```javascript
// Users can only access their own data
// Authentication is required for all operations
// Default deny policy for unknown collections
```

See [FIREBASE_SECURITY.md](FIREBASE_SECURITY.md) for detailed security configuration.

### **Collections**
- `users/{userId}` - User authentication data
- `profiles/{userId}` - User profile information  
- `routes/{routeId}` - Cycling routes (planned)
- `settings/{userId}` - User settings (planned)

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (latest stable)
- Firebase CLI
- Android Studio / VS Code
- Git

### **Setup**
1. **Clone the repository**
   ```bash
   git clone https://github.com/dmsolop/Velogo.git
   cd Velogo/velogo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   firebase init
   firebase deploy --only firestore:rules
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

**Note:** This project uses production Firebase services. No local emulators are required.

### **Development Commands**

```bash
# Code Generation
flutter packages pub run build_runner build

# Testing
flutter test                    # Run all tests
flutter test test/domain/auth/  # Run specific tests

# Analysis
flutter analyze

# Clean & Rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 🧪 Testing

### **Test Structure**
```
test/
├── domain/           # Unit tests for use cases
│   └── auth/        # Auth feature tests
├── integration/      # Integration tests
├── bloc/            # BLoC tests
└── screens/         # Widget tests
```

### **Running Tests**
```bash
# All tests
flutter test

# Specific test categories
flutter test test/domain/
flutter test test/integration/
flutter test test/bloc/
```

## 📁 Project Structure

```
lib/
├── core/                    # Shared code
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── services/           # Core services
│   ├── constants/          # App constants
│   └── usecases/           # Base use case
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── map/               # Route planning
│   ├── weather/           # Weather data
│   ├── navigation/        # App navigation
│   ├── profile/           # User profile
│   └── settings/          # App settings
├── shared/                # Shared components
└── config/                # App configuration
```

## 🔒 Security

- **Firebase Security Rules** - All operations require authentication
- **User Data Isolation** - Users can only access their own data
- **Input Validation** - Comprehensive validation in use cases
- **Error Handling** - Centralized error handling with Either

## 🤝 Contributing

### **Development Guidelines**
1. **Follow Clean Architecture** - Respect layer boundaries
2. **Feature-first Organization** - Keep features self-contained
3. **Use Dependency Injection** - Register all dependencies in GetIt
4. **Write Tests** - Unit tests for use cases, integration tests for features
5. **Error Handling** - Use Either<Failure, Success> pattern
6. **Code Quality** - Follow Dart/Flutter best practices

### **Adding New Features**
1. Create feature directory structure
2. Implement domain layer (entities, use cases)
3. Implement data layer (models, repositories)
4. Implement presentation layer (BLoCs, pages)
5. Register dependencies in DI container
6. Write tests
7. Update documentation

## 📊 Migration Progress

- **ETAP 1-4**: ✅ 100% - Preparation, Auth, Map, Cleanup
- **ETAP 5-7**: ✅ 100% - Weather, Navigation, Settings
- **ETAP 8**: ✅ 100% - Profile Feature
- **ETAP 9**: 🔄 30% - Testing (Auth tests complete)
- **ETAP 10**: 🔄 50% - Documentation (in progress)

## 📝 License

This project is licensed under the MIT License.

---

**Built with ❤️ using Flutter and Clean Architecture**
