import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/navigation_entity.dart';

part 'navigation_state.freezed.dart';

@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState({
    @Default(NavigationTab.home) NavigationTab selectedTab,
  }) = _NavigationState;
}
