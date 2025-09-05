import 'package:flutter/material.dart';

/// Отримання кольору на основі складності маршруту
Color getColorBasedOnDifficulty(double difficulty) {
  if (difficulty < 2.0) {
    return const Color(0xFF4CAF50); // Зелений
  } else if (difficulty < 4.0) {
    return const Color(0xFFFF9800); // Помаранчевий
  } else if (difficulty < 6.0) {
    return const Color(0xFFFF5722); // Червоний
  } else if (difficulty < 8.0) {
    return const Color(0xFF9C27B0); // Фіолетовий
  } else {
    return const Color(0xFF000000); // Чорний
  }
}
