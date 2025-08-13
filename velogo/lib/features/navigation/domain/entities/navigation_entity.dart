import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_entity.freezed.dart';

@freezed
class NavigationEntity with _$NavigationEntity {
  const factory NavigationEntity({
    required NavigationTab selectedTab,
    required DateTime lastNavigationTime,
    required String currentRoute,
  }) = _NavigationEntity;
}

enum NavigationTab { home, myRoutes, profile, settings }
