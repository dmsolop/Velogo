import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/services/health_metrics.dart';
import '../../../domain/entities/route_entity.dart';

part 'section_parameters_update_state.freezed.dart';

/// Стан оновлення параметрів секцій маршруту
///
/// Використовується для реалтайм оновлення параметрів секцій
/// (elevationGain, windEffect, difficulty, averageSpeed)
@freezed
class SectionParametersUpdateState with _$SectionParametersUpdateState {
  /// Початковий стан (нічого не оновлюється)
  const factory SectionParametersUpdateState.initial() = _Initial;

  /// Оновлення параметрів розпочато
  const factory SectionParametersUpdateState.updating({
    required int totalSections,
    required int completedSections,
  }) = _Updating;

  /// Одна секція оновлена
  const factory SectionParametersUpdateState.sectionUpdated({
    required RouteSectionEntity updatedSection,
    required int sectionIndex,
    required int totalSections,
    required int completedSections,
  }) = _SectionUpdated;

  /// Всі секції оновлені
  const factory SectionParametersUpdateState.completed({
    required List<RouteSectionEntity> allSections,
  }) = _Completed;

  /// Помилка при оновленні
  const factory SectionParametersUpdateState.error({
    required String message,
    required int sectionIndex,
  }) = _Error;
}

