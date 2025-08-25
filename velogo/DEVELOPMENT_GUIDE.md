# 🚀 ГАЙД ПО РОЗРОБЦІ VELOGO

## **📋 Зміст**
1. [Архітектура проекту](#архітектура-проекту)
2. [Додавання нового Feature](#додавання-нового-feature)
3. [Тестування](#тестування)
4. [Dependency Injection](#dependency-injection)
5. [Error Handling](#error-handling)
6. [Code Style](#code-style)
7. [Git Workflow](#git-workflow)

---

## **🏗️ Архітектура проекту**

### **Clean Architecture з Feature-first підходом**

```
lib/
├── core/                    # Спільний код
│   ├── di/                 # Dependency Injection
│   ├── error/              # Обробка помилок
│   ├── services/           # Базові сервіси
│   ├── constants/          # Константи
│   └── usecases/           # Базовий UseCase
├── features/               # Features (модулі)
│   ├── auth/              # Аутентифікація
│   ├── map/               # Карти та маршрути
│   ├── weather/           # Погода
│   ├── navigation/        # Навігація
│   ├── profile/           # Профіль
│   └── settings/          # Налаштування
├── shared/                # Спільні компоненти
└── config/                # Конфігурація
```

### **Шари архітектури (для кожного feature):**

```
feature_name/
├── data/                  # Data Layer
│   ├── datasources/       # Джерела даних
│   ├── models/           # DTO моделі
│   └── repositories/     # Реалізації репозиторіїв
├── domain/               # Domain Layer
│   ├── entities/         # Бізнес-сутності
│   ├── repositories/     # Інтерфейси репозиторіїв
│   └── usecases/         # Use Cases
└── presentation/         # Presentation Layer
    ├── bloc/            # State Management
    ├── pages/           # Екрани
    └── widgets/         # Віджети
```

---

## **➕ Додавання нового Feature**

### **Крок 1: Створення структури директорій**

```bash
# Створюємо структуру для нового feature
mkdir -p lib/features/new_feature/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
```

### **Крок 2: Створення Domain Layer**

#### **2.1 Entity (Бізнес-сутність)**
```dart
// lib/features/new_feature/domain/entities/new_feature_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_feature_entity.freezed.dart';

@freezed
class NewFeatureEntity with _$NewFeatureEntity {
  const factory NewFeatureEntity({
    @Default('') String id,
    @Default('') String name,
    // Додайте інші поля
  }) = _NewFeatureEntity;
}
```

#### **2.2 Repository Interface**
```dart
// lib/features/new_feature/domain/repositories/new_feature_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/new_feature_entity.dart';

abstract class NewFeatureRepository {
  Future<Either<Failure, NewFeatureEntity>> getNewFeature(String id);
  Future<Either<Failure, List<NewFeatureEntity>>> getAllNewFeatures();
  Future<Either<Failure, Unit>> saveNewFeature(NewFeatureEntity entity);
}
```

#### **2.3 Use Cases**
```dart
// lib/features/new_feature/domain/usecases/get_new_feature_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/new_feature_entity.dart';
import '../repositories/new_feature_repository.dart';

class GetNewFeatureUseCase implements UseCase<NewFeatureEntity, String> {
  final NewFeatureRepository repository;

  GetNewFeatureUseCase(this.repository);

  @override
  Future<Either<Failure, NewFeatureEntity>> call(String id) async {
    // Валідація
    if (id.isEmpty) {
      return Left(ValidationFailure('ID cannot be empty'));
    }
    
    return await repository.getNewFeature(id);
  }
}
```

### **Крок 3: Створення Data Layer**

#### **3.1 Model (DTO)**
```dart
// lib/features/new_feature/data/models/new_feature_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/new_feature_entity.dart';

part 'new_feature_model.freezed.dart';
part 'new_feature_model.g.dart';

@freezed
class NewFeatureModel with _$NewFeatureModel {
  const factory NewFeatureModel({
    @Default('') String id,
    @Default('') String name,
    // Додайте інші поля
  }) = _NewFeatureModel;

  factory NewFeatureModel.fromJson(Map<String, dynamic> json) =>
      _$NewFeatureModelFromJson(json);
}

// Extension для конвертації
extension NewFeatureModelExtension on NewFeatureModel {
  NewFeatureEntity toDomain() => NewFeatureEntity(
    id: id,
    name: name,
  );
}

extension NewFeatureEntityExtension on NewFeatureEntity {
  NewFeatureModel toModel() => NewFeatureModel(
    id: id,
    name: name,
  );
}
```

#### **3.2 Data Source**
```dart
// lib/features/new_feature/data/datasources/new_feature_remote_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/new_feature_model.dart';

abstract class NewFeatureRemoteDataSource {
  Future<NewFeatureModel> getNewFeature(String id);
  Future<List<NewFeatureModel>> getAllNewFeatures();
  Future<void> saveNewFeature(NewFeatureModel model);
}

class NewFeatureRemoteDataSourceImpl implements NewFeatureRemoteDataSource {
  final FirebaseFirestore firestore;

  NewFeatureRemoteDataSourceImpl({required this.firestore});

  @override
  Future<NewFeatureModel> getNewFeature(String id) async {
    final doc = await firestore.collection('new_features').doc(id).get();
    return NewFeatureModel.fromJson(doc.data()!);
  }

  @override
  Future<List<NewFeatureModel>> getAllNewFeatures() async {
    final querySnapshot = await firestore.collection('new_features').get();
    return querySnapshot.docs
        .map((doc) => NewFeatureModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> saveNewFeature(NewFeatureModel model) async {
    await firestore.collection('new_features').doc(model.id).set(model.toJson());
  }
}
```

#### **3.3 Repository Implementation**
```dart
// lib/features/new_feature/data/repositories/new_feature_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/new_feature_entity.dart';
import '../../domain/repositories/new_feature_repository.dart';
import '../datasources/new_feature_remote_data_source.dart';

class NewFeatureRepositoryImpl implements NewFeatureRepository {
  final NewFeatureRemoteDataSource remoteDataSource;

  NewFeatureRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NewFeatureEntity>> getNewFeature(String id) async {
    try {
      final model = await remoteDataSource.getNewFeature(id);
      return Right(model.toDomain());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<NewFeatureEntity>>> getAllNewFeatures() async {
    try {
      final models = await remoteDataSource.getAllNewFeatures();
      return Right(models.map((model) => model.toDomain()).toList());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveNewFeature(NewFeatureEntity entity) async {
    try {
      await remoteDataSource.saveNewFeature(entity.toModel());
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
```

### **Крок 4: Створення Presentation Layer**

#### **4.1 State**
```dart
// lib/features/new_feature/presentation/bloc/new_feature/new_feature_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/new_feature_entity.dart';
import '../../../../core/error/failures.dart';

part 'new_feature_state.freezed.dart';

@freezed
class NewFeatureState with _$NewFeatureState {
  const factory NewFeatureState.initial() = _Initial;
  const factory NewFeatureState.loading() = _Loading;
  const factory NewFeatureState.loaded(NewFeatureEntity entity) = _Loaded;
  const factory NewFeatureState.error(Failure failure) = _Error;
}
```

#### **4.2 Cubit**
```dart
// lib/features/new_feature/presentation/bloc/new_feature/new_feature_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_new_feature_usecase.dart';
import 'new_feature_state.dart';

class NewFeatureCubit extends Cubit<NewFeatureState> {
  final GetNewFeatureUseCase getNewFeatureUseCase;

  NewFeatureCubit({required this.getNewFeatureUseCase})
      : super(const NewFeatureState.initial());

  Future<void> loadNewFeature(String id) async {
    emit(const NewFeatureState.loading());
    
    final result = await getNewFeatureUseCase(id);
    result.fold(
      (failure) => emit(NewFeatureState.error(failure)),
      (entity) => emit(NewFeatureState.loaded(entity)),
    );
  }
}
```

#### **4.3 Page**
```dart
// lib/features/new_feature/presentation/pages/new_feature_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/new_feature/new_feature_cubit.dart';
import '../bloc/new_feature/new_feature_state.dart';

class NewFeaturePage extends StatelessWidget {
  final String id;

  const NewFeaturePage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NewFeatureCubit>()..loadNewFeature(id),
      child: Scaffold(
        appBar: AppBar(title: const Text('New Feature')),
        body: BlocBuilder<NewFeatureCubit, NewFeatureState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (entity) => _buildContent(entity),
              error: (failure) => _buildError(failure),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(entity) {
    return Center(
      child: Text('Feature: ${entity.name}'),
    );
  }

  Widget _buildError(failure) {
    return Center(
      child: Text('Error: ${failure.message}'),
    );
  }
}
```

### **Крок 5: Dependency Injection**

```dart
// Додайте в lib/core/di/injection_container.dart
void _initNewFeature() {
  // Data sources
  getIt.registerLazySingleton<NewFeatureRemoteDataSource>(
    () => NewFeatureRemoteDataSourceImpl(firestore: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<NewFeatureRepository>(
    () => NewFeatureRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetNewFeatureUseCase(getIt()));

  // Cubit
  getIt.registerFactory(() => NewFeatureCubit(getNewFeatureUseCase: getIt()));
}
```

---

## **🧪 Тестування**

### **Unit Tests для Use Cases**

```dart
// test/domain/new_feature/get_new_feature_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:velogo/features/new_feature/domain/usecases/get_new_feature_usecase.dart';
import 'package:velogo/features/new_feature/domain/repositories/new_feature_repository.dart';
import 'package:velogo/core/error/failures.dart';

class MockNewFeatureRepository extends Mock implements NewFeatureRepository {}

void main() {
  late GetNewFeatureUseCase useCase;
  late MockNewFeatureRepository mockRepository;

  setUp(() {
    mockRepository = MockNewFeatureRepository();
    useCase = GetNewFeatureUseCase(mockRepository);
  });

  test('should get new feature from repository', () async {
    // arrange
    const id = 'test_id';
    const entity = NewFeatureEntity(id: id, name: 'Test Feature');
    when(mockRepository.getNewFeature(id))
        .thenAnswer((_) async => Right(entity));

    // act
    final result = await useCase(id);

    // assert
    expect(result, Right(entity));
    verify(mockRepository.getNewFeature(id));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when id is empty', () async {
    // act
    final result = await useCase('');

    // assert
    expect(result, Left(ValidationFailure('ID cannot be empty')));
    verifyZeroInteractions(mockRepository);
  });
}
```

### **Integration Tests**

```dart
// test/integration/new_feature_integration_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:velogo/features/new_feature/data/repositories/new_feature_repository_impl.dart';
import 'package:velogo/features/new_feature/data/datasources/new_feature_remote_data_source.dart';

void main() {
  late NewFeatureRepositoryImpl repository;
  late NewFeatureRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = NewFeatureRemoteDataSourceImpl(firestore: FirebaseFirestore.instance);
    repository = NewFeatureRepositoryImpl(remoteDataSource: dataSource);
  });

  test('should get new feature from Firebase', () async {
    // arrange
    const id = 'test_id';

    // act
    final result = await repository.getNewFeature(id);

    // assert
    expect(result.isRight(), true);
  });
}
```

---

## **🔧 Dependency Injection**

### **Реєстрація залежностей**

```dart
// lib/core/di/injection_container.dart
final getIt = GetIt.instance;

Future<void> init() async {
  // Core
  await _initCore();
  
  // Features
  _initAuth();
  _initMap();
  _initWeather();
  _initNavigation();
  _initProfile();
  _initSettings();
  _initNewFeature(); // Додайте новий feature
}

void _initNewFeature() {
  // Data sources
  getIt.registerLazySingleton<NewFeatureRemoteDataSource>(
    () => NewFeatureRemoteDataSourceImpl(firestore: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<NewFeatureRepository>(
    () => NewFeatureRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetNewFeatureUseCase(getIt()));

  // Cubit
  getIt.registerFactory(() => NewFeatureCubit(getNewFeatureUseCase: getIt()));
}
```

---

## **🛡️ Error Handling**

### **Failure Classes**

```dart
// lib/core/error/failures.dart
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation failed']) : super(message);
}
```

### **Використання Either**

```dart
// В use cases
Future<Either<Failure, T>> call(Params params) async {
  // Валідація
  if (params.isEmpty) {
    return Left(ValidationFailure('Parameter cannot be empty'));
  }
  
  // Бізнес-логіка
  return await repository.someMethod(params);
}

// В UI
result.fold(
  (failure) => emit(State.error(failure)),
  (data) => emit(State.loaded(data)),
);
```

---

## **📝 Code Style**

### **Naming Conventions**

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`

### **File Organization**

```
feature_name/
├── data/
│   ├── datasources/
│   │   └── feature_remote_data_source.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       ├── get_feature_usecase.dart
│       └── save_feature_usecase.dart
└── presentation/
    ├── bloc/
    │   └── feature/
    │       ├── feature_cubit.dart
    │       └── feature_state.dart
    ├── pages/
    │   └── feature_page.dart
    └── widgets/
        └── feature_widget.dart
```

---

## **🔄 Git Workflow**

### **Commit Messages**

```
feat: Add new feature functionality
fix: Fix bug in existing feature
refactor: Refactor existing code
test: Add or update tests
docs: Update documentation
style: Fix code formatting
```

### **Branch Naming**

```
feature/add-new-feature
bugfix/fix-validation-issue
refactor/improve-error-handling
```

### **Pull Request Process**

1. **Створіть feature branch**
2. **Зробіть зміни**
3. **Напишіть тести**
4. **Оновіть документацію**
5. **Створіть Pull Request**
6. **Code Review**
7. **Merge**

---

## **✅ Checklist для нового Feature**

- [ ] Створена структура директорій
- [ ] Реалізований Domain Layer (Entity, Repository, Use Cases)
- [ ] Реалізований Data Layer (Model, Data Source, Repository Impl)
- [ ] Реалізований Presentation Layer (State, Cubit, Page)
- [ ] Додано Dependency Injection
- [ ] Написано Unit тести
- [ ] Написано Integration тести
- [ ] Оновлено документацію
- [ ] Додано Firebase security rules (якщо потрібно)
- [ ] Протестовано на реальному пристрої

---

**🎯 Ціль: Створювати якісний, тестований та масштабований код!**
