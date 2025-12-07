import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'section_parameters_update_state.dart';
import '../../../../../core/services/health_metrics.dart';
import '../../../../../core/services/log_service.dart';
import '../../../domain/entities/route_entity.dart';
import '../../../../profile/domain/entities/profile_entity.dart';
import '../../../domain/usecases/calculate_section_parameters_usecase.dart';
import '../../../../weather/data/models/weather_data.dart';

/// Cubit для реалтайм оновлення параметрів секцій маршруту
///
/// Функціональність:
/// - Оновлює параметри секцій (elevationGain, windEffect) асинхронно
/// - Емітить проміжні стани для відображення прогресу
/// - Підготовлено для інтеграції з WeatherCubit (реалтайм оновлення при зміні погоди)
///
/// Використовується в: CreateRouteScreen для поступового оновлення складності
class SectionParametersUpdateCubit extends Cubit<SectionParametersUpdateState> {
  final UpdateSectionParametersUseCase _updateSectionParametersUseCase;

  SectionParametersUpdateCubit(this._updateSectionParametersUseCase)
      : super(const SectionParametersUpdateState.initial());

  /// Почати оновлення параметрів для списку секцій
  ///
  /// Параметри:
  /// - sections: список секцій для оновлення
  /// - profile: профіль користувача
  /// - weatherData: погодні дані (опціонально)
  /// - healthMetrics: health-метрики (опціонально)
  ///
  /// Емітить:
  /// - _Updating при початку
  /// - _SectionUpdated для кожної оновленої секції
  /// - _Completed коли всі секції оновлені
  /// - _Error при помилці
  Future<void> updateSectionsParameters({
    required List<RouteSectionEntity> sections,
    required ProfileEntity profile,
    WeatherData? weatherData,
    HealthMetrics? healthMetrics,
  }) async {
    if (sections.isEmpty) {
      emit(const SectionParametersUpdateState.completed(allSections: []));
      return;
    }

    emit(SectionParametersUpdateState.updating(
      totalSections: sections.length,
      completedSections: 0,
    ));

    LogService.log('🔄 [SectionParametersUpdateCubit] Почато оновлення параметрів для ${sections.length} секцій');

    final updatedSections = <RouteSectionEntity>[];

    // Оновлюємо кожну секцію асинхронно
    for (int i = 0; i < sections.length; i++) {
      final section = sections[i];
      if (section.coordinates.length < 2) continue;

      final sectionStart = section.coordinates.first;
      final sectionEnd = section.coordinates.last;

      // Створюємо SectionParameters з поточних значень секції
      final currentParams = SectionParameters(
        elevationGain: section.elevationGain,
        windEffect: section.windEffect,
        surfaceType: section.surfaceType,
        difficulty: section.difficulty,
        averageSpeed: section.averageSpeed,
        distance: section.distance,
      );

      // Оновлюємо параметри через Use Case
      final updateResult = await _updateSectionParametersUseCase(
        UpdateSectionParametersParams(
          currentParameters: currentParams,
          coordinates: section.coordinates,
          startPoint: sectionStart,
          endPoint: sectionEnd,
          userProfile: profile,
          weatherData: weatherData,
          healthMetrics: healthMetrics,
        ),
      );

      updateResult.fold(
        (failure) {
          LogService.log('❌ [SectionParametersUpdateCubit] Помилка оновлення секції $i: ${failure.message}');
          emit(SectionParametersUpdateState.error(
            message: failure.message ?? 'Помилка оновлення параметрів секції',
            sectionIndex: i,
          ));
          return; // Продовжуємо з наступною секцією
        },
        (updatedParams) {
          // Створюємо оновлену секцію
          final updatedSection = RouteSectionEntity(
            id: section.id,
            coordinates: section.coordinates,
            distance: updatedParams.distance,
            elevationGain: updatedParams.elevationGain,
            surfaceType: updatedParams.surfaceType,
            windEffect: updatedParams.windEffect,
            difficulty: updatedParams.difficulty,
            averageSpeed: updatedParams.averageSpeed,
          );

          updatedSections.add(updatedSection);

          // Емітимо проміжний стан для кожної оновленої секції
          emit(SectionParametersUpdateState.sectionUpdated(
            updatedSection: updatedSection,
            sectionIndex: i,
            totalSections: sections.length,
            completedSections: updatedSections.length,
          ));

          LogService.log('✅ [SectionParametersUpdateCubit] Секція $i оновлена: difficulty=${updatedParams.difficulty}, elevation=${updatedParams.elevationGain}m');
        },
      );
    }

    // Емітимо фінальний стан коли всі секції оновлені
    emit(SectionParametersUpdateState.completed(
      allSections: updatedSections,
    ));

    LogService.log('✅ [SectionParametersUpdateCubit] Оновлення параметрів завершено для ${updatedSections.length} секцій');
  }

  /// Скинути стан до початкового
  void reset() {
    emit(const SectionParametersUpdateState.initial());
  }
}

