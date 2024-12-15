// import 'package:latlong2/latlong.dart';
import 'route_section.dart';

void calculateSectionDifficulty(List<RouteSection> sections) {
  for (var section in sections) {
    section.difficulty = (section.elevationGain * 0.5) +
        (getSurfaceTypeScore(section.surfaceType) * 0.3) +
        (section.windEffect * 0.2);
  }
}

double getSurfaceTypeScore(String surfaceType) {
  switch (surfaceType) {
    case 'asphalt':
      return 10;
    case 'gravel':
      return 0;
    case 'sand':
      return -10;
    default:
      return 0;
  }
}
