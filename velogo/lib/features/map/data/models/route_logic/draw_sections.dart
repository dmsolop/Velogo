import 'package:flutter/material.dart';
import '../../datasources/route_difficulty_service.dart';

/// Отримання кольору на основі складності маршруту
Color getColorBasedOnDifficulty(double difficulty) {
  final routeDifficultyService = RouteDifficultyService();
  final colorValue = routeDifficultyService.getDifficultyColor(difficulty);
  return Color(colorValue);
}
