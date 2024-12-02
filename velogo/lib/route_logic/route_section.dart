import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class RouteSection {
  final List<LatLng> coordinates; // Координати секції
  final double elevationGain; // Набір висоти
  final String surfaceType; // Тип покриття (асфальт, ґрунт тощо)
  final double windEffect; // Вплив вітру (попутний або зустрічний)
  double difficulty; // Розрахована складність (від -10 до 10)

  RouteSection({
    required this.coordinates,
    required this.elevationGain,
    required this.surfaceType,
    required this.windEffect,
    this.difficulty = 0,
  });
}
