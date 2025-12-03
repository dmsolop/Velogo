# Архітектура побудови та перетягування маршрутів

## 📋 Зміст

1. [Загальна архітектура](#загальна-архітектура)
2. [Побудова маршрутів](#побудова-маршрутів)
3. [Перетягування маршрутів](#перетягування-маршрутів)
4. [Детальний опис компонентів](#детальний-опис-компонентів)
5. [Потоки даних](#потоки-даних)

---

## 🏗️ Загальна архітектура

### Принципи архітектури

Проєкт використовує **Clean Architecture** з розділенням на шари:

```
┌─────────────────────────────────────────────────────────┐
│              PRESENTATION LAYER                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │  CreateRouteScreen (UI + State Management)       │  │
│  │  - Відображення карти                            │  │
│  │  - Обробка подій користувача                     │  │
│  │  - Управління станом маршруту                    │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│              DOMAIN LAYER                                │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Use Cases                                       │  │
│  │  - CalculateRouteUseCase                         │  │
│  │  - CalculateRouteDistanceUseCase                 │  │
│  │  - CalculateElevationGainUseCase                │  │
│  │  - CalculateWindEffectUseCase                    │  │
│  └──────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Entities                                         │  │
│  │  - RouteEntity                                    │  │
│  │  - RouteSectionEntity                             │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│              DATA LAYER                                  │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Repositories                                     │  │
│  │  - RoutingRepositoryImpl                         │  │
│  └──────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Core Services                                    │  │
│  │  - RoadRoutingService                             │  │
│  │  - RouteDragService                               │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

## 🛣️ Побудова маршрутів

### Загальний потік побудови маршруту

```
Користувач натискає на карту
         ↓
CreateRouteScreen._addRoutePoint()
         ↓
CalculateRouteUseCase.call()
         ↓
RoutingRepositoryImpl.calculateRoute()
         ↓
RoadRoutingService.calculateRouteWithErrorHandling()
         ↓
┌─────────────────────────────────────┐
│  Перевірка умов:                    │
│  1. Інтернет доступний?             │
│  2. API ключ налаштовано?           │
│  3. Спробувати онлайн API           │
│  4. Спробувати офлайн карти         │
│  5. Fallback на розумний маршрут    │
└─────────────────────────────────────┘
         ↓
Повернення RouteCalculationResult
         ↓
Створення RouteSectionEntity
         ↓
Додавання до _sections
         ↓
Оновлення UI (відображення на карті)
```

### Детальний опис процесу

#### 1. **CreateRouteScreen._addRoutePoint()**

**Місцезнаходження:** `lib/features/map/presentation/pages/create_route_screen.dart:162`

**Функціональність:**
- Обробляє натискання користувача на карту
- Викликає Use Case для розрахунку маршруту
- Створює нову секцію маршруту (`RouteSectionEntity`)
- Оновлює стан віджета

**Код:**
```dart
void _addRoutePoint(LatLng point) async {
  if (_lastPoint != null) {
    // 1. Розрахунок маршруту через Use Case
    final routeResult = await _calculateRouteUseCase(
      CalculateRouteParams(
        startPoint: _lastPoint!,
        endPoint: point,
        profile: _getRouteProfile(),
      ),
    );

    // 2. Обробка результату
    routeResult.fold(
      (failure) => _showRouteErrorFromFailure(failure),
      (routeCoordinates) async {
        // 3. Розрахунок додаткових параметрів
        final distance = await _calculateRouteDistanceUseCase(...);
        final elevationGain = await _calculateElevationGainUseCase(...);
        final windEffect = await _calculateWindEffectUseCase(...);

        // 4. Створення секції маршруту
        final newSection = RouteSectionEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          coordinates: routeCoordinates,
          distance: distance,
          elevationGain: elevationGain,
          surfaceType: RoadSurfaceType.asphalt,
          windEffect: windEffect,
          difficulty: 0.0,
          averageSpeed: 15.0,
        );

        // 5. Додавання до списку секцій
        setState(() {
          _sections.add(newSection);
        });
      },
    );
  }
  _lastPoint = point; // Зберігаємо точку для наступного з'єднання
}
```

**Важливі моменти:**
- Використовує `_lastPoint` для з'єднання з попередньою точкою
- Створює окрему секцію для кожної ділянки маршруту
- Обробляє помилки через `fold()` з Either типу

---

#### 2. **CalculateRouteUseCase**

**Місцезнаходження:** `lib/features/map/domain/usecases/calculate_route_usecase.dart`

**Функціональність:**
- Абстракція бізнес-логіки розрахунку маршруту
- Викликає Repository для отримання даних
- Повертає `Either<Failure, List<LatLng>>`

**Код:**
```dart
class CalculateRouteUseCase implements UseCase<List<LatLng>, CalculateRouteParams> {
  final RoutingRepository repository;

  @override
  Future<Either<Failure, List<LatLng>>> call(CalculateRouteParams params) async {
    return await repository.calculateRoute(
      startPoint: params.startPoint,
      endPoint: params.endPoint,
      profile: params.profile,
    );
  }
}
```

**Переваги:**
- Ізоляція бізнес-логіки від UI
- Легке тестування
- Можливість заміни реалізації

---

#### 3. **RoutingRepositoryImpl**

**Місцезнаходження:** `lib/features/map/data/repositories/routing_repository_impl.dart`

**Функціональність:**
- Реалізація інтерфейсу Repository
- Викликає `RoadRoutingService` для розрахунку
- Мапить помилки на `Failure` типи

**Код:**
```dart
@override
Future<Either<Failure, List<LatLng>>> calculateRoute({
  required LatLng startPoint,
  required LatLng endPoint,
  required String profile,
}) async {
  try {
    final result = await RoadRoutingService.calculateRouteWithErrorHandling(
      startPoint: startPoint,
      endPoint: endPoint,
      profile: profile,
    );

    if (result.isFailure) {
      return Left(Failure.routeCalculation(
        result.errorMessage,
        result.error!,
      ));
    }

    return Right(result.coordinates!);
  } catch (e) {
    return Left(ServerFailure('Помилка розрахунку маршруту: $e'));
  }
}
```

---

#### 4. **RoadRoutingService.calculateRouteWithErrorHandling()**

**Місцезнаходження:** `lib/core/services/road_routing_service.dart:75`

**Функціональність:**
- Головний метод розрахунку маршруту з детальною обробкою помилок
- Послідовна перевірка умов та спроб розрахунку
- Повертає `RouteCalculationResult` з детальною інформацією про помилки

**Алгоритм роботи:**

```
1. Перевірка інтернету
   ├─ Немає → RouteCalculationError.noInternet
   └─ Є → Продовжуємо

2. Перевірка API ключа
   ├─ Не налаштовано → RouteCalculationError.noApiKey + Crashlytics
   └─ Налаштовано → Продовжуємо

3. Спроба онлайн API
   ├─ Успіх → Повертаємо координати
   └─ Помилка → Продовжуємо

4. Перевірка офлайн карт
   ├─ Немає → RouteCalculationError.noOfflineMaps
   └─ Є → Продовжуємо

5. Спроба офлайн маршрутизації
   ├─ Успіх → Повертаємо координати
   └─ Помилка → RouteCalculationError.offlineCalculationFailed + Crashlytics
```

**Код:**
```dart
static Future<RouteCalculationResult> calculateRouteWithErrorHandling({
  required LatLng startPoint,
  required LatLng endPoint,
  String profile = 'cycling-regular',
}) async {
  // 1. Перевірка інтернету
  final hasInternet = await _isInternetAvailable();
  if (!hasInternet) {
    return RouteCalculationResult.failure(
      RouteCalculationError.noInternet,
      'Немає інтернет-з\'єднання...',
    );
  }

  // 2. Перевірка API ключа
  final apiKey = _remoteConfig.openRouteServiceApiKey;
  if (apiKey == 'YOUR_OPENROUTESERVICE_API_KEY_HERE' || apiKey.isEmpty) {
    await CrashlyticsService().reportRouteCalculationError(...);
    return RouteCalculationResult.failure(
      RouteCalculationError.noApiKey,
      'API ключ не налаштовано...',
    );
  }

  // 3. Спроба онлайн API
  final onlineRoute = await _calculateOnlineRoute(startPoint, endPoint, profile);
  if (onlineRoute.isNotEmpty) {
    return RouteCalculationResult.success(onlineRoute);
  }

  // 4. Перевірка офлайн карт
  final hasOfflineMaps = await _hasOfflineMapsForArea(startPoint, endPoint);
  if (!hasOfflineMaps) {
    return RouteCalculationResult.failure(
      RouteCalculationError.noOfflineMaps,
      'Немає офлайн карт...',
    );
  }

  // 5. Спроба офлайн маршрутизації
  final offlineRoute = await _calculateRouteWithOfflineMaps(startPoint, endPoint, profile);
  if (offlineRoute.isNotEmpty) {
    return RouteCalculationResult.success(offlineRoute);
  }

  // 6. Все не спрацювало
  await CrashlyticsService().reportRouteCalculationError(...);
  return RouteCalculationResult.failure(
    RouteCalculationError.offlineCalculationFailed,
    'Не вдалося розрахувати маршрут...',
  );
}
```

---

#### 5. **RoadRoutingService._calculateOnlineRoute()**

**Місцезнаходження:** `lib/core/services/road_routing_service.dart:226`

**Функціональність:**
- Виконує HTTP POST запит до OpenRouteService API
- Парсить GeoJSON відповідь
- Декодує encoded polyline (якщо потрібно)

**Структура запиту:**
```json
{
  "coordinates": [
    [longitude1, latitude1],
    [longitude2, latitude2]
  ],
  "format": "geojson",
  "instructions": false,
  "options": {
    "avoid_features": ["ferries", "tunnels"]
  }
}
```

**Код:**
```dart
static Future<List<LatLng>> _calculateOnlineRoute(
  LatLng startPoint, 
  LatLng endPoint, 
  String profile
) async {
  final url = '$baseUrl/directions/$profile';
  
  final body = {
    'coordinates': [
      [startPoint.longitude, startPoint.latitude],
      [endPoint.longitude, endPoint.latitude]
    ],
    'format': 'geojson',
    'instructions': false,
    'options': {
      'avoid_features': _getAvoidFeaturesForProfile(profile),
    }
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return _extractCoordinatesFromGeoJSON(data);
  } else {
    await CrashlyticsService().reportRouteCalculationError(...);
    return [];
  }
}
```

---

#### 6. **RoadRoutingService._extractCoordinatesFromGeoJSON()**

**Місцезнаходження:** `lib/core/services/road_routing_service.dart:458`

**Функціональність:**
- Парсить GeoJSON відповідь від OpenRouteService
- Підтримує два формати:
  1. **Encoded polyline** (рядок)
  2. **Coordinates array** (масив координат)

**Алгоритм:**
```
1. Перевірка наявності 'routes'
   ├─ Є → Перевіряємо geometry в routes[0]
   └─ Немає → Перевіряємо 'features'

2. Перевірка типу geometry
   ├─ String → Декодуємо polyline
   └─ Map → Витягуємо coordinates

3. Конвертація координат
   └─ [longitude, latitude] → LatLng(latitude, longitude)
```

**Код:**
```dart
static List<LatLng> _extractCoordinatesFromGeoJSON(Map<String, dynamic> data) {
  // Перевірка routes (OpenRouteService формат)
  if (data.containsKey('routes')) {
    final routes = data['routes'] as List;
    if (routes.isNotEmpty) {
      final route = routes.first;
      
      if (route.containsKey('geometry')) {
        final geometry = route['geometry'];
        
        // Encoded polyline string
        if (geometry is String) {
          return _decodePolyline(geometry);
        }
        
        // Coordinates array
        if (geometry is Map && geometry.containsKey('coordinates')) {
          final coordinates = geometry['coordinates'] as List;
          return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
        }
      }
    }
  }
  
  // Перевірка features (стандартний GeoJSON)
  if (data.containsKey('features')) {
    // Аналогічна логіка...
  }
  
  return [];
}
```

---

#### 7. **Відображення маршруту на карті**

**Місцезнаходження:** `lib/features/map/presentation/pages/create_route_screen.dart:238`

**Функціональність:**
- Генерує `Polyline` об'єкти для кожної секції маршруту
- Визначає колір на основі складності (`getColorBasedOnDifficulty`)
- Підсвічує секцію, яку перетягують

**Код:**
```dart
List<Polyline> _generatePolylines() {
  final polylines = <Polyline>[];

  for (final entry in _sections.asMap().entries) {
    final index = entry.key;
    final section = entry.value;
    final color = getColorBasedOnDifficulty(section.difficulty);
    final isDragging = _isDragging && _draggedSegmentIndex == index;

    // Основна лінія
    polylines.add(Polyline(
      points: section.coordinates,
      color: isDragging ? Colors.orange : color,
      strokeWidth: isDragging ? 6 : 4,
    ));

    // Підсвітка для перетягування
    if (isDragging) {
      polylines.add(Polyline(
        points: section.coordinates,
        color: Colors.orange.withOpacity(0.3),
        strokeWidth: 8,
      ));
    }
  }

  return polylines;
}
```

---

## 🖱️ Перетягування маршрутів

### Загальний потік перетягування

```
Користувач робить довге натискання на маршрут
         ↓
CreateRouteScreen._handleLongPressOnRoute()
         ↓
Пошук найближчого відрізка (_findNearestSegment)
         ↓
Активація режиму перетягування (_isDragging = true)
         ↓
Користувач натискає в новому місці
         ↓
CreateRouteScreen._handleSegmentDrag()
         ↓
CreateRouteScreen._moveRouteSection()
         ↓
Оновлення координат секції
         ↓
Перерахунок відстані
         ↓
Оновлення UI
```

### Детальний опис процесу

#### 1. **Активація режиму перетягування**

**Місцезнаходження:** `lib/features/map/presentation/pages/create_route_screen.dart:748`

**Функціональність:**
- Обробляє довге натискання на маршрут
- Перевіряє чи увімкнено перетягування в налаштуваннях
- Знаходить найближчий відрізок маршруту
- Активує режим перетягування

**Код:**
```dart
void _handleLongPressOnRoute(LatLng point) {
  // 1. Перевірка умов
  if (!RouteDragService.isDragEnabled || _sections.isEmpty) {
    return;
  }

  // 2. Пошук найближчого відрізка
  final nearestSegmentIndex = _findNearestSegment(point);
  if (nearestSegmentIndex == -1) {
    return;
  }

  // 3. Активація режиму
  setState(() {
    _isDragging = true;
    _draggedSegmentIndex = nearestSegmentIndex;
  });

  // 4. Підказка користувачу
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Натисніть в новому місці для переміщення точки маршруту'),
    ),
  );
}
```

---

#### 2. **Пошук найближчого відрізка**

**Місцезнаходження:** `lib/features/map/presentation/pages/create_route_screen.dart:946`

**Функціональність:**
- Перебирає всі секції маршруту
- Для кожної секції перебирає всі відрізки (пари точок)
- Розраховує відстань від точки натискання до кожного відрізка
- Повертає індекс секції з найближчим відрізком

**Алгоритм:**
```
Для кожної секції в _sections:
  Для кожної пари точок (i, i+1) в секції:
    Розрахувати відстань від точки натискання до відрізка
    Якщо відстань менша за мінімальну:
      Зберегти індекс секції
      Оновити мінімальну відстань

Повернути індекс секції з найближчим відрізком
```

**Код:**
```dart
int _findNearestSegment(LatLng point) {
  double minDistance = double.infinity;
  int nearestIndex = -1;

  // Перебираємо всі секції
  for (int i = 0; i < _sections.length; i++) {
    final section = _sections[i];

    // Перебираємо всі відрізки в секції
    for (int j = 0; j < section.coordinates.length - 1; j++) {
      final segmentStart = section.coordinates[j];
      final segmentEnd = section.coordinates[j + 1];

      // Розраховуємо відстань від точки до відрізка
      final distance = _distanceToLineSegment(point, segmentStart, segmentEnd);

      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }
  }

  return nearestIndex;
}
```

---

#### 3. **Розрахунок відстані до відрізка**

**Місцезнаходження:** `lib/features/map/presentation/pages/create_route_screen.dart:1173`

**Функціональність:**
- Розраховує найкоротшу відстань від точки до відрізка
- Використовує векторну математику для проекції точки на відрізок

**Алгоритм:**
```
1. Обчислюємо вектори:
   A = point - lineStart
   B = lineEnd - lineStart

2. Обчислюємо скалярний добуток:
   dot = A · B
   lenSq = |B|²

3. Обчислюємо параметр проекції:
   param = dot / lenSq

4. Визначаємо найближчу точку на відрізку:
   - Якщо param < 0 → найближча точка = lineStart
   - Якщо param > 1 → найближча точка = lineEnd
   - Інакше → найближча точка = lineStart + param * B

5. Розраховуємо відстань:
   distance = |point - найближча точка|
```

**Код:**
```dart
double _distanceToLineSegment(LatLng point, LatLng lineStart, LatLng lineEnd) {
  final A = point.latitude - lineStart.latitude;
  final B = point.longitude - lineStart.longitude;
  final C = lineEnd.latitude - lineStart.latitude;
  final D = lineEnd.longitude - lineStart.longitude;

  final dot = A * C + B * D;
  final lenSq = C * C + D * D;

  if (lenSq == 0) {
    return sqrt(A * A + B * B);
  }

  final param = dot / lenSq;

  double xx, yy;
  if (param < 0) {
    xx = lineStart.latitude;
    yy = lineStart.longitude;
  } else if (param > 1) {
    xx = lineEnd.latitude;
    yy = lineEnd.longitude;
  } else {
    xx = lineStart.latitude + param * C;
    yy = lineStart.longitude + param * D;
  }

  final dx = point.latitude - xx;
  final dy = point.longitude - yy;
  return sqrt(dx * dx + dy * dy);
}
```

---

#### 4. **Обробка перетягування**

**Місцезнаходження:** `lib/features/map/presentation/pages/create_route_screen.dart:792`

**Функціональність:**
- Обробляє натискання після активації режиму перетягування
- Викликає `_moveRouteSection` для переміщення секції
- Скидає режим перетягування після завершення

**Код:**
```dart
Future<void> _handleSegmentDrag(LatLng newPosition) async {
  if (!_isDragging || _draggedSegmentIndex == null) {
    return;
  }

  try {
    // Переміщуємо секцію
    await _moveRouteSection(newPosition, _draggedSegmentIndex!);

    // Скидаємо режим
    setState(() {
      _isDragging = false;
      _draggedSegmentIndex = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Точка маршруту переміщена')),
    );
  } catch (e) {
    LogService.log('❌ Помилка при переміщенні секції: $e');
  }
}
```

---

#### 5. **Переміщення секції маршруту**

**Місцезнаходження:** `lib/features/map/presentation/pages/create_route_screen.dart:845`

**Функціональність:**
- Знаходить найближчу точку в секції до нової позиції
- Оновлює координати цієї точки
- Перераховує відстань секції
- **НЕ перераховує маршрут через API** (щоб уникнути зайвих гілок)

**Важливий момент:**
Цей метод **НЕ** викликає API для перерахунку маршруту. Замість цього він просто оновлює координати найближчої точки в секції. Це запобігає створенню зайвих гілок маршруту.

**Код:**
```dart
Future<void> _moveRouteSection(LatLng newPosition, int segmentIndex) async {
  if (segmentIndex < 0 || segmentIndex >= _sections.length) {
    return;
  }

  final section = _sections[segmentIndex];

  // 1. Знаходимо найближчу точку в секції
  int closestPointIndex = _findClosestPointInSection(
    section.coordinates, 
    newPosition
  );

  // 2. Створюємо нові координати з переміщеною точкою
  final newCoordinates = List<LatLng>.from(section.coordinates);
  newCoordinates[closestPointIndex] = newPosition;

  // 3. Оновлюємо секцію (БЕЗ перерахунку через API)
  final updatedSection = section.copyWith(
    coordinates: newCoordinates,
    distance: _calculateDistance(newCoordinates),
  );

  // 4. Оновлюємо список секцій
  setState(() {
    _sections[segmentIndex] = updatedSection;
  });
}
```

---

#### 6. **Пошук найближчої точки в секції**

**Місцезнаходження:** `lib/features/map/presentation/pages/create_route_screen.dart:881`

**Функціональність:**
- Перебирає всі точки в секції
- Розраховує відстань від кожної точки до цільової позиції
- Повертає індекс найближчої точки

**Код:**
```dart
int _findClosestPointInSection(List<LatLng> coordinates, LatLng targetPoint) {
  double minDistance = double.infinity;
  int closestIndex = 0;

  for (int i = 0; i < coordinates.length; i++) {
    final distance = _calculateDistanceBetweenPoints(
      coordinates[i], 
      targetPoint
    );
    
    if (distance < minDistance) {
      minDistance = distance;
      closestIndex = i;
    }
  }

  return closestIndex;
}
```

---

#### 7. **RouteDragService (не використовується в поточній реалізації)**

**Місцезнаходження:** `lib/core/services/route_drag_service.dart`

**Примітка:** Цей сервіс існує в коді, але **НЕ використовується** в поточній реалізації перетягування. Він містить більш складну логіку з:
- Прилипанням до найближчої дороги (`_snapToNearestRoad`)
- Перерахунком маршруту через API (`_recalculateRouteWithNewPoint`)

**Чому не використовується:**
Поточна реалізація використовує простіший підхід - просто оновлює координати точки без перерахунку через API, щоб уникнути створення зайвих гілок маршруту.

---

## 🔧 Детальний опис компонентів

### Структура даних

#### **RouteSectionEntity**

**Місцезнаходження:** `lib/features/map/domain/entities/route_entity.dart:28`

**Структура:**
```dart
@freezed
class RouteSectionEntity with _$RouteSectionEntity {
  const factory RouteSectionEntity({
    required String id,                    // Унікальний ідентифікатор
    required List<LatLng> coordinates,      // Координати секції
    required double distance,               // Відстань в метрах
    required double elevationGain,          // Набір висоти в метрах
    required RoadSurfaceType surfaceType,   // Тип покриття
    required double windEffect,             // Вплив вітру
    required double difficulty,             // Складність (0-10)
    required double averageSpeed,           // Середня швидкість км/год
    String? notes,                          // Додаткові нотатки
  }) = _RouteSectionEntity;
}
```

**Особливості:**
- Immutable (Freezed)
- Використовує `copyWith` для оновлення
- Зберігається в `_sections: List<RouteSectionEntity>`

---

#### **RouteCalculationResult**

**Місцезнаходження:** `lib/core/services/road_routing_service.dart:20`

**Структура:**
```dart
class RouteCalculationResult {
  final List<LatLng>? coordinates;
  final RouteCalculationError? error;
  final String? errorMessage;

  RouteCalculationResult.success(this.coordinates)
      : error = null, errorMessage = null;
  
  RouteCalculationResult.failure(this.error, this.errorMessage)
      : coordinates = null;

  bool get isSuccess => coordinates != null;
  bool get isFailure => error != null;
}
```

**Використання:**
- Обгортає результат розрахунку маршруту
- Містить детальну інформацію про помилки
- Використовується в `RoadRoutingService`

---

### Обробка помилок

#### **RouteCalculationError**

**Місцезнаходження:** `lib/core/services/road_routing_service.dart:10`

**Типи помилок:**
```dart
enum RouteCalculationError {
  noInternet,              // Немає інтернету
  noApiKey,                // Немає API ключа
  apiError,                // Помилка API
  noOfflineMaps,           // Немає офлайн карт
  offlineCalculationFailed, // Помилка офлайн розрахунку
  unknown,                 // Невідома помилка
}
```

**Категорії:**
- **userActionable**: `noInternet`, `noOfflineMaps`
- **developerIssue**: `noApiKey`
- **systemError**: `apiError`, `offlineCalculationFailed`, `unknown`

---

#### **Failure**

**Місцезнаходження:** `lib/core/error/failures.dart:6`

**Структура:**
```dart
@freezed
class Failure with _$Failure {
  const factory Failure.server([String? message]) = ServerFailure;
  const factory Failure.cache([String? message]) = CacheFailure;
  const factory Failure.network([String? message]) = NetworkFailure;
  const factory Failure.auth([String? message]) = AuthFailure;
  const factory Failure.validation([String? message]) = ValidationFailure;
  const factory Failure.permission([String? message]) = PermissionFailure;
  const factory Failure.routeCalculation([
    String? message,
    RouteCalculationError? errorType,
  ]) = RouteCalculationFailure;
}
```

**Використання:**
- Використовується в Use Cases через `Either<Failure, T>`
- Мапиться з `RouteCalculationError` в Repository

---

### Профілі маршрутизації

**Місцезнаходження:** `lib/core/services/road_routing_service.dart:615`

**Доступні профілі:**
- `cycling-regular` - велосипедні дороги (за замовчуванням)
- `driving-car` - автомобільні дороги
- `foot-walking` - пішохідні стежки

**Визначення профілю:**
```dart
String _getRouteProfile() {
  final settingsState = context.read<SettingsCubit>().state;
  return settingsState.maybeWhen(
    loaded: (settings) => settings.routeProfile ?? 'cycling-regular',
    orElse: () => 'cycling-regular',
  );
}
```

---

## 📊 Потоки даних

### Потік побудови маршруту

```
┌─────────────────┐
│  Користувач     │
│  натискає       │
│  на карту       │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ CreateRouteScreen        │
│ _addRoutePoint()         │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ CalculateRouteUseCase    │
│ call()                   │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ RoutingRepositoryImpl    │
│ calculateRoute()        │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ RoadRoutingService       │
│ calculateRouteWith...() │
└────────┬────────────────┘
         │
         ├─► Перевірка інтернету
         ├─► Перевірка API ключа
         ├─► Спроба онлайн API
         ├─► Перевірка офлайн карт
         └─► Спроба офлайн маршрутизації
         │
         ▼
┌─────────────────────────┐
│ RouteCalculationResult   │
│ (координати або помилка) │
└────────┬────────────────┘
         │
         ├─► Success → Створення RouteSectionEntity
         └─► Failure → Показ діалогу помилки
         │
         ▼
┌─────────────────────────┐
│ Оновлення UI             │
│ (_sections.add())        │
└─────────────────────────┘
```

---

### Потік перетягування маршруту

```
┌─────────────────┐
│  Користувач     │
│  довге          │
│  натискання     │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ CreateRouteScreen        │
│ _handleLongPressOnRoute()│
└────────┬────────────────┘
         │
         ├─► Перевірка RouteDragService.isDragEnabled
         ├─► Пошук найближчого відрізка
         └─► Активація режиму (_isDragging = true)
         │
         ▼
┌─────────────────┐
│  Користувач     │
│  натискає       │
│  в новому місці │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ CreateRouteScreen        │
│ _handleSegmentDrag()     │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ CreateRouteScreen        │
│ _moveRouteSection()      │
└────────┬────────────────┘
         │
         ├─► Пошук найближчої точки в секції
         ├─► Оновлення координат
         └─► Перерахунок відстані
         │
         ▼
┌─────────────────────────┐
│ Оновлення UI             │
│ (_sections[index] = ...) │
└─────────────────────────┘
```

---

## 🎯 Ключові особливості реалізації

### 1. **Секційна структура маршруту**

Маршрут складається з **секцій** (`RouteSectionEntity`), де кожна секція:
- Має свої координати
- Має свою відстань, набір висоти, складність
- Відображається окремою полілінією на карті

**Переваги:**
- Можливість редагувати окремі секції
- Різна складність для різних ділянок
- Легше обчислювати загальні параметри маршруту

---

### 2. **Відсутність перерахунку при перетягуванні**

При перетягуванні секції **НЕ** викликається API для перерахунку маршруту. Замість цього:
- Оновлюються координати найближчої точки
- Перераховується відстань локально
- Структура маршруту зберігається

**Чому:**
- Уникаємо створення зайвих гілок
- Швидше відгук UI
- Менше навантаження на API

---

### 3. **Детальна обробка помилок**

Система має трирівневу обробку помилок:
1. **RouteCalculationError** - детальні типи помилок
2. **RouteCalculationResult** - обгортка з повідомленнями
3. **Failure** - стандартизовані помилки для Use Cases

**Переваги:**
- Детальна інформація для користувача
- Автоматична відправка в Crashlytics
- Правильна категорізація помилок

---

### 4. **Адаптивні налаштування карти**

Карта автоматично адаптується:
- Під розмір екрану
- Під кількість точок маршруту
- Під контекст використання (створення/перегляд)

**Реалізація:**
```dart
MapOptions _createAdaptiveMapOptions() {
  final adaptiveOptions = AdaptiveMapOptions(
    context: MapContext.routeCreation,
    routePoints: _sections.expand((s) => s.coordinates).toList(),
    screenSize: MediaQuery.of(context).size,
    enableAutoFit: routePoints != null && routePoints.length > 1,
  );
  return adaptiveOptions.toMapOptions();
}
```

---

## 📝 Висновки

### Сильні сторони

1. **Clean Architecture** - чітке розділення відповідальностей
2. **Детальна обробка помилок** - користувач завжди знає що сталося
3. **Секційна структура** - гнучкість у редагуванні маршруту
4. **Оптимізація перетягування** - швидкий відгук без зайвих API викликів

### Можливі покращення

1. **RouteDragService** - зараз не використовується, можна видалити або інтегрувати
2. **Офлайн маршрутизація** - зараз використовує простий fallback
3. **Кешування маршрутів** - можна додати для швидшого доступу
4. **Візуальна індикація** - можна покращити підсвітку при перетягуванні

---

## 🔗 Пов'язані файли

### Presentation Layer
- `lib/features/map/presentation/pages/create_route_screen.dart` - головний екран
- `lib/features/map/presentation/pages/route_screen.dart` - екран перегляду маршруту

### Domain Layer
- `lib/features/map/domain/usecases/calculate_route_usecase.dart`
- `lib/features/map/domain/usecases/calculate_route_distance_usecase.dart`
- `lib/features/map/domain/entities/route_entity.dart`

### Data Layer
- `lib/features/map/data/repositories/routing_repository_impl.dart`
- `lib/core/services/road_routing_service.dart`
- `lib/core/services/route_drag_service.dart`

### Error Handling
- `lib/core/error/failures.dart`
- `lib/core/services/crashlytics_service.dart`

