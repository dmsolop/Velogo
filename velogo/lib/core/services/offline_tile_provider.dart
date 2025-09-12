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

      // Якщо тайл не в кеші, використовуємо fallback сервер
      LogService.log('🌐 [OfflineTileProvider] Використовуємо fallback сервер: ${coordinates.z}/${coordinates.x}/${coordinates.y}');
      return await _loadFromNetwork(key, decode);
    } catch (e) {
      LogService.log('❌ [OfflineTileProvider] Помилка завантаження тайлу: $e');
      return await _loadFromNetwork(key, decode);
    }
  }

  Future<ui.Codec> _loadFromNetwork(OfflineTileImage key, ImageDecoderCallback decode) async {
    try {
      final url = '$fallbackServer/${coordinates.z}/${coordinates.x}/${coordinates.y}.png';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final buffer = await ui.ImmutableBuffer.fromUint8List(response.bodyBytes);
        return await decode(buffer);
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      LogService.log('❌ [OfflineTileProvider] Помилка мережевого завантаження: $e');
      rethrow;
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
