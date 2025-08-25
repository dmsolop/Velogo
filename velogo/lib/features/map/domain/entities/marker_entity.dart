import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'marker_entity.freezed.dart';

@freezed
class MarkerEntity with _$MarkerEntity {
  const factory MarkerEntity({
    required String id,
    required String name,
    required MarkerType type,
    required LatLng coordinates,
    required String description,
    String? iconPath,
    String? imageUrl,
    double? rating,
    Map<String, dynamic>? metadata,
    @Default(true) bool isVisible,
    @Default(false) bool isSelected,
  }) = _MarkerEntity;
}

enum MarkerType {
  // Основні типи
  start, // Початок маршруту
  end, // Кінець маршруту
  waypoint, // Проміжна точка

  // Цікаві місця
  historical, // Історичні місцини
  shop, // Магазини/Маркети
  water, // Вода (фонтани, джерела)
  parking, // Стоянки

  // Інфраструктура
  cafe, // Кафе/Ресторани
  hotel, // Готелі
  gasStation, // АЗС
  repair, // Ремонт велосипедів
  toilet, // Туалети

  // Природа
  viewpoint, // Оглядові майданчики
  park, // Парки
  forest, // Ліси
  lake, // Озера

  // Транспорт
  busStop, // Автобусні зупинки
  trainStation, // Залізничні станції
  bikeRental, // Пункти прокату велосипедів

  // Безпека
  police, // Поліція
  hospital, // Лікарні
  pharmacy, // Аптеки

  // Користувацькі
  custom, // Користувацькі мітки
}

@freezed
class MarkerCategoryEntity with _$MarkerCategoryEntity {
  const factory MarkerCategoryEntity({
    required String id,
    required String name,
    required String displayName,
    required List<MarkerType> markerTypes,
    required String iconPath,
    required bool isVisible,
    required int order,
    String? description,
  }) = _MarkerCategoryEntity;
}

@freezed
class MarkerSearchResultEntity with _$MarkerSearchResultEntity {
  const factory MarkerSearchResultEntity({
    required List<MarkerEntity> markers,
    required int totalCount,
    required String searchQuery,
    required MarkerSearchType searchType,
    List<MarkerCategoryEntity>? categories,
  }) = _MarkerSearchResultEntity;
}

enum MarkerSearchType {
  byName, // Пошук за назвою
  byType, // Пошук за типом
  byCategory, // Пошук за категорією
  byLocation, // Пошук за місцезнаходженням
  byRadius, // Пошук в радіусі
  custom, // Користувацький пошук
}
