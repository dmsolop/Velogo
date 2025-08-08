enum RoadSurface {
  asphalt, // Асфальт - мінімальний вплив дощу
  concrete, // Бетон - мінімальний вплив дощу
  gravel, // Гравій - помірний вплив дощу
  dirt, // Ґрунт - сильний вплив дощу
  mud, // Багно - критичний вплив дощу
}

extension RoadSurfaceExtension on RoadSurface {
  /// Коефіцієнт впливу дощу на складність
  double get precipitationImpact {
    switch (this) {
      case RoadSurface.asphalt:
        return 0.1; // Мінімальний вплив
      case RoadSurface.concrete:
        return 0.1; // Мінімальний вплив
      case RoadSurface.gravel:
        return 0.3; // Помірний вплив
      case RoadSurface.dirt:
        return 0.8; // Сильний вплив
      case RoadSurface.mud:
        return 1.5; // Критичний вплив
    }
  }

  /// Назва покриття
  String get displayName {
    switch (this) {
      case RoadSurface.asphalt:
        return 'Асфальт';
      case RoadSurface.concrete:
        return 'Бетон';
      case RoadSurface.gravel:
        return 'Гравій';
      case RoadSurface.dirt:
        return 'Ґрунт';
      case RoadSurface.mud:
        return 'Багно';
    }
  }

  /// Опис впливу дощу
  String get precipitationDescription {
    switch (this) {
      case RoadSurface.asphalt:
        return 'Мінімальний вплив дощу';
      case RoadSurface.concrete:
        return 'Мінімальний вплив дощу';
      case RoadSurface.gravel:
        return 'Помірний вплив дощу';
      case RoadSurface.dirt:
        return 'Сильний вплив дощу';
      case RoadSurface.mud:
        return 'Критичний вплив дощу';
    }
  }
}
