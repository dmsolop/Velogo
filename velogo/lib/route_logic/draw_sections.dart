import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
import 'route_section.dart';

void drawRouteSections(
    List<RouteSection> sections, MapController mapController) {
  for (var section in sections) {
    final color = getColorBasedOnDifficulty(section.difficulty);
    final polyline = Polyline(
      points: section.coordinates,
      color: color,
      strokeWidth: 5,
    );
    // Додайте цю лінію до шару карти
  }
}

Color getColorBasedOnDifficulty(double difficulty) {
  if (difficulty > 0) {
    return Colors.green;
  } else if (difficulty == 0) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}
