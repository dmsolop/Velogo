import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'offline_map_service.dart';
import '../services/log_service.dart';

/// Провайдер тайлів для офлайн карт
class OfflineTileProvider extends TileProvider {
  final String fallbackTileServer;

  OfflineTileProvider({
    this.fallbackTileServer = 'https://tile.openstreetmap.org',
  });

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return OfflineTileImage(
      coordinates: coordinates,
      fallbackServer: fallbackTileServer,
    );
  }
}

/// Клас для зображення офлайн тайлів
class OfflineTileImage extends ImageProvider<OfflineTileImage> {
  final TileCoordinates coordinates;
  final String fallbackServer;

  OfflineTileImage({
    required this.coordinates,
    required this.fallbackServer,
  });

  @override
  ImageStreamCompleter loadImage(OfflineTileImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      debugLabel: 'OfflineTile(${coordinates.x},${coordinates.y},${coordinates.z})',
    );
  }

  Future<ui.Codec> _loadAsync(OfflineTileImage key, ImageDecoderCallback decode) async {
    try {
      // Спочатку намагаємося отримати тайл з кешу
      final cachedTile = await OfflineMapService.getTile(
        coordinates.x,
        coordinates.y,
        coordinates.z,
      );

      if (cachedTile != null) {
        LogService.log('📁 [OfflineTileProvider] Використовуємо кешований тайл: ${coordinates.z}/${coordinates.x}/${coordinates.y}');
        final buffer = await ui.ImmutableBuffer.fromUint8List(cachedTile);
        return await decode(buffer);
      }

      // Якщо тайл не в кеші, спробуємо завантажити з мережі
      try {
        return await _loadFromNetwork(key, decode);
      } catch (networkError) {
        // Якщо не вдалося завантажити з мережі, створюємо placeholder
        // Логуємо тільки перший раз для кожного zoom рівня, щоб не спамити
        if (coordinates.z <= 10) {
          LogService.log('⚠️ [OfflineTileProvider] Немає інтернету або тайлів в кеші, використовуємо placeholder для zoom ${coordinates.z}');
        }
        return await _createPlaceholderTile(key, decode);
      }
    } catch (e) {
      // Якщо виникла інша помилка, також створюємо placeholder
      LogService.log('❌ [OfflineTileProvider] Помилка завантаження тайлу, використовуємо placeholder: $e');
      return await _createPlaceholderTile(key, decode);
    }
  }

  Future<ui.Codec> _loadFromNetwork(OfflineTileImage key, ImageDecoderCallback decode) async {
    final url = '$fallbackServer/${coordinates.z}/${coordinates.x}/${coordinates.y}.png';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final buffer = await ui.ImmutableBuffer.fromUint8List(response.bodyBytes);
      return await decode(buffer);
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  }

  /// Створює placeholder тайл (сіре зображення) коли не вдається завантажити
  Future<ui.Codec> _createPlaceholderTile(OfflineTileImage key, ImageDecoderCallback decode) async {
    // Створюємо просте сіре зображення 256x256 через Canvas
    const int tileSize = 256;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    // Малюємо сірий прямокутник
    final paint = Paint()..color = const Color(0xFFE0E0E0);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, tileSize.toDouble(), tileSize.toDouble()),
      paint,
    );
    
    // Конвертуємо в зображення
    final picture = recorder.endRecording();
    final image = await picture.toImage(tileSize, tileSize);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    if (byteData != null) {
      final buffer = await ui.ImmutableBuffer.fromUint8List(byteData.buffer.asUint8List());
      return await decode(buffer);
    } else {
      // Якщо не вдалося створити через Canvas, використовуємо простий підхід
      throw Exception('Не вдалося створити placeholder');
    }
  }

  @override
  Future<OfflineTileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  bool operator ==(Object other) {
    if (other is! OfflineTileImage) return false;
    return coordinates == other.coordinates && fallbackServer == other.fallbackServer;
  }

  @override
  int get hashCode => Object.hash(coordinates, fallbackServer);
}
