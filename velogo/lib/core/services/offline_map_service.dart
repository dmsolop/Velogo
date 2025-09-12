import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../services/log_service.dart';

/// Сервіс для роботи з офлайн картами
class OfflineMapService {
  static const String _cacheDirName = 'offline_maps';
  static const int _maxCacheSize = 100 * 1024 * 1024; // 100MB

  /// Завантажити та зберегти тайли для області
  static Future<void> downloadMapTiles({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
    required int minZoom,
    required int maxZoom,
    String tileServer = 'https://tile.openstreetmap.org',
  }) async {
    try {
      LogService.log('🗺️ [OfflineMapService] Початок завантаження тайлів для області: lat($minLat-$maxLat), lng($minLng-$maxLng), zoom($minZoom-$maxZoom)');

      final cacheDir = await _getCacheDirectory();
      if (cacheDir == null) {
        LogService.log('❌ [OfflineMapService] Не вдалося отримати директорію кешу');
        return;
      }

      int downloadedTiles = 0;
      int totalTiles = 0;

      // Підрахунок загальної кількості тайлів
      for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
        final tiles = _calculateTilesForZoom(minLat, maxLat, minLng, maxLng, zoom);
        totalTiles += tiles.length;
      }

      LogService.log('📊 [OfflineMapService] Потрібно завантажити $totalTiles тайлів');

      // Завантаження тайлів для кожного рівня zoom
      for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
        final tiles = _calculateTilesForZoom(minLat, maxLat, minLng, maxLng, zoom);

        for (final tile in tiles) {
          await _downloadTile(tileServer, tile.x, tile.y, zoom, cacheDir);
          downloadedTiles++;

          // Логування прогресу
          if (downloadedTiles % 10 == 0) {
            LogService.log('📥 [OfflineMapService] Завантажено $downloadedTiles/$totalTiles тайлів');
          }

          // Перевірка розміру кешу
          if (await _getCacheSize() > _maxCacheSize) {
            LogService.log('⚠️ [OfflineMapService] Досягнуто максимальний розмір кешу, зупиняємо завантаження');
            break;
          }
        }
      }

      LogService.log('✅ [OfflineMapService] Завантаження завершено: $downloadedTiles тайлів');
    } catch (e) {
      LogService.log('❌ [OfflineMapService] Помилка завантаження: $e');
    }
  }

  /// Отримати тайл з кешу або завантажити
  static Future<Uint8List?> getTile(int x, int y, int z) async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (cacheDir == null) return null;

      final tileFile = File('${cacheDir.path}/$z/$x/$y.png');

      if (await tileFile.exists()) {
        LogService.log('📁 [OfflineMapService] Тайл знайдено в кеші: $z/$x/$y');
        return await tileFile.readAsBytes();
      }

      // Якщо тайл не в кеші, спробуємо завантажити
      LogService.log('🌐 [OfflineMapService] Завантаження тайлу: $z/$x/$y');
      return await _downloadTileDirectly(x, y, z);
    } catch (e) {
      LogService.log('❌ [OfflineMapService] Помилка отримання тайлу: $e');
      return null;
    }
  }

  /// Перевірити чи є тайл в кеші
  static Future<bool> isTileCached(int x, int y, int z) async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (cacheDir == null) return false;

      final tileFile = File('${cacheDir.path}/$z/$x/$y.png');
      return await tileFile.exists();
    } catch (e) {
      return false;
    }
  }

  /// Очистити кеш карт
  static Future<void> clearCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (cacheDir == null) return;

      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        LogService.log('🗑️ [OfflineMapService] Кеш карт очищено');
      }
    } catch (e) {
      LogService.log('❌ [OfflineMapService] Помилка очищення кешу: $e');
    }
  }

  /// Отримати розмір кешу
  static Future<int> getCacheSize() async {
    return await _getCacheSize();
  }

  /// Отримати статистику кешу
  static Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (cacheDir == null) {
        return {'size': 0, 'tiles': 0, 'zoomLevels': []};
      }

      int totalSize = 0;
      int totalTiles = 0;
      List<int> zoomLevels = [];

      if (await cacheDir.exists()) {
        final zoomDirs = await cacheDir.list().toList();

        for (final zoomDir in zoomDirs) {
          if (zoomDir is Directory) {
            final zoom = int.tryParse(zoomDir.path.split('/').last);
            if (zoom != null) {
              zoomLevels.add(zoom);

              final xDirs = await zoomDir.list().toList();
              for (final xDir in xDirs) {
                if (xDir is Directory) {
                  final yFiles = await xDir.list().toList();
                  for (final yFile in yFiles) {
                    if (yFile is File) {
                      totalSize += await yFile.length();
                      totalTiles++;
                    }
                  }
                }
              }
            }
          }
        }
      }

      return {
        'size': totalSize,
        'tiles': totalTiles,
        'zoomLevels': zoomLevels..sort(),
      };
    } catch (e) {
      LogService.log('❌ [OfflineMapService] Помилка отримання статистики: $e');
      return {'size': 0, 'tiles': 0, 'zoomLevels': []};
    }
  }

  // Приватні методи

  static Future<Directory?> _getCacheDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${appDir.path}/$_cacheDirName');

      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      return cacheDir;
    } catch (e) {
      LogService.log('❌ [OfflineMapService] Помилка створення директорії кешу: $e');
      return null;
    }
  }

  static Future<void> _downloadTile(String server, int x, int y, int z, Directory cacheDir) async {
    try {
      final url = '$server/$z/$x/$y.png';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final tileDir = Directory('${cacheDir.path}/$z/$x');
        if (!await tileDir.exists()) {
          await tileDir.create(recursive: true);
        }

        final tileFile = File('${tileDir.path}/$y.png');
        await tileFile.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      LogService.log('❌ [OfflineMapService] Помилка завантаження тайлу $z/$x/$y: $e');
    }
  }

  static Future<Uint8List?> _downloadTileDirectly(int x, int y, int z) async {
    try {
      final url = 'https://tile.openstreetmap.org/$z/$x/$y.png';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      LogService.log('❌ [OfflineMapService] Помилка прямого завантаження тайлу: $e');
    }
    return null;
  }

  static List<MapTile> _calculateTilesForZoom(double minLat, double maxLat, double minLng, double maxLng, int zoom) {
    final minTile = _latLngToTile(minLat, minLng, zoom);
    final maxTile = _latLngToTile(maxLat, maxLng, zoom);

    List<MapTile> tiles = [];

    for (int x = minTile.x; x <= maxTile.x; x++) {
      for (int y = minTile.y; y <= maxTile.y; y++) {
        tiles.add(MapTile(x: x, y: y));
      }
    }

    return tiles;
  }

  static MapTile _latLngToTile(double lat, double lng, int zoom) {
    final n = pow(2, zoom).toDouble();
    final x = ((lng + 180) / 360 * n).floor();
    final y = ((1 - log(tan(lat * pi / 180) + 1 / cos(lat * pi / 180)) / pi) / 2 * n).floor();
    return MapTile(x: x, y: y);
  }

  static Future<int> _getCacheSize() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (cacheDir == null) return 0;

      int totalSize = 0;

      if (await cacheDir.exists()) {
        await for (final entity in cacheDir.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }
}

/// Клас для представлення тайлу карти
class MapTile {
  final int x;
  final int y;

  MapTile({required this.x, required this.y});
}
