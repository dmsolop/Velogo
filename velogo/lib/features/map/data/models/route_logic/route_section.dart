import 'package:latlong2/latlong.dart';

class RouteSection {
  final String id; // Унікальний ідентифікатор секції
  final List<LatLng> coordinates; // Координати секції
  final double distance; // Відстань секції
  final double elevationGain; // Набір висоти
  final String surfaceType; // Тип покриття (асфальт, ґрунт тощо)
  final double windEffect; // Вплив вітру (попутний або зустрічний)
  final double averageSpeed; // Середня швидкість
  final String? notes; // Додаткові нотатки
  double difficulty; // Розрахована складність (від -10 до 10)

  RouteSection({
    required this.id,
    required this.coordinates,
    required this.distance,
    required this.elevationGain,
    required this.surfaceType,
    required this.windEffect,
    required this.averageSpeed,
    this.notes,
    this.difficulty = 0,
  });
}
