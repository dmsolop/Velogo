import 'package:flutter/material.dart';
import '../../../../shared/base_colors.dart';
import '../../../../shared/base_widgets.dart';
import '../../../../core/services/offline_map_service.dart';
import '../../../../core/services/log_service.dart';

class OfflineMapsSettingsScreen extends StatefulWidget {
  const OfflineMapsSettingsScreen({super.key});

  @override
  State<OfflineMapsSettingsScreen> createState() => _OfflineMapsSettingsScreenState();
}

class _OfflineMapsSettingsScreenState extends State<OfflineMapsSettingsScreen> {
  Map<String, dynamic> _cacheStats = {};
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _downloadStatus = '';

  @override
  void initState() {
    super.initState();
    _loadCacheStats();
  }

  Future<void> _loadCacheStats() async {
    final stats = await OfflineMapService.getCacheStats();
    setState(() {
      _cacheStats = stats;
    });
  }

  Future<void> _downloadCurrentArea() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _downloadStatus = 'Початок завантаження...';
    });

    try {
      // Завантажуємо карти для Києва (приклад)
      await OfflineMapService.downloadMapTiles(
        minLat: 50.2132,
        maxLat: 50.5908,
        minLng: 30.2394,
        maxLng: 30.8259,
        minZoom: 10,
        maxZoom: 16,
      );

      setState(() {
        _downloadStatus = 'Завантаження завершено!';
        _downloadProgress = 1.0;
      });

      await _loadCacheStats();
    } catch (e) {
      setState(() {
        _downloadStatus = 'Помилка завантаження: $e';
      });
      LogService.log('❌ [OfflineMapsSettings] Помилка завантаження: $e');
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистити кеш карт'),
        content: const Text('Ви впевнені, що хочете видалити всі збережені карти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await OfflineMapService.clearCache();
      await _loadCacheStats();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Кеш карт очищено')),
        );
      }
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Офлайн карти',
          style: TextStyle(color: BaseColors.white),
        ),
        backgroundColor: BaseColors.background,
        iconTheme: const IconThemeData(color: BaseColors.white),
      ),
      backgroundColor: BaseColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Статистика кешу
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BaseColors.backgroundDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: 'Статистика кешу',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: BaseColors.white,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: 'Розмір:',
                        fontSize: 14,
                        color: BaseColors.white,
                      ),
                      CustomText(
                        text: _formatBytes(_cacheStats['size'] ?? 0),
                        fontSize: 14,
                        color: BaseColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: 'Тайлів:',
                        fontSize: 14,
                        color: BaseColors.white,
                      ),
                      CustomText(
                        text: '${_cacheStats['tiles'] ?? 0}',
                        fontSize: 14,
                        color: BaseColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: 'Рівні zoom:',
                        fontSize: 14,
                        color: BaseColors.white,
                      ),
                      CustomText(
                        text: '${(_cacheStats['zoomLevels'] as List?)?.join(', ') ?? 'Немає'}',
                        fontSize: 14,
                        color: BaseColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Кнопки дій
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isDownloading ? null : _downloadCurrentArea,
                    icon: _isDownloading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download),
                    label: Text(_isDownloading ? 'Завантаження...' : 'Завантажити карти Києва'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BaseColors.primary,
                      foregroundColor: BaseColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isDownloading ? null : _clearCache,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Очистити кеш'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: BaseColors.white,
                      side: const BorderSide(color: BaseColors.white),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Прогрес завантаження
            if (_isDownloading) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BaseColors.backgroundDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Завантаження карт',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: BaseColors.white,
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _downloadProgress,
                      backgroundColor: BaseColors.background,
                      valueColor: const AlwaysStoppedAnimation<Color>(BaseColors.primary),
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: _downloadStatus,
                      fontSize: 12,
                      color: BaseColors.white,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Інформація
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BaseColors.backgroundDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Інформація',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BaseColors.white,
                  ),
                  SizedBox(height: 8),
                  CustomText(
                    text: '• Офлайн карти дозволяють використовувати додаток без інтернету\n'
                        '• Рекомендується завантажити карти для часто використовуваних областей\n'
                        '• Карти займають місце на пристрої, тому періодично очищайте кеш',
                    fontSize: 12,
                    color: BaseColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
