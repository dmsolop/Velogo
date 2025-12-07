import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class LogService {
  // static final _logFile = File('/storage/emulated/0/Download/mod_debug_log.txt');
  static File? _logFile;
  static bool _isCleaning = false;
  static final List<String> _queuedLogs = [];

  static Future<void> init() async {
    try {
      final directory = await getExternalStorageDirectory(); // ✅ Безпечна директорія
      if (directory == null) {
        debugPrint('LogService: Failed to get external storage directory');
        return;
      }

      final logPath = '${directory.path}/mod_debug_log.txt';
      _logFile = File(logPath);

      if (!await _logFile!.exists()) {
        await _logFile!.create(recursive: true);
      }

      // Записуємо сигнальний рядок про ініціалізацію
      final initMessage = '[LogService] ✅ INITIALIZED at ${DateTime.now().toIso8601String()}\n';
      final pathMessage = '[LogService] 📁 Log file path: $logPath\n';
      final separator = '=' * 80 + '\n';

      await _logFile!.writeAsString(separator + initMessage + pathMessage + separator, mode: FileMode.append);
      debugPrint('LogService initialized. Log file path: $logPath');
    } catch (e) {
      debugPrint('LogService init error: $e');
    }
  }

  static Future<void> log(String message) async {
    final now = DateTime.now().toIso8601String();
    final logLine = '[$now] $message\n';
    debugPrint(logLine);

    if (_isCleaning) {
      _queuedLogs.add(logLine);
      return;
    }

    if (_logFile != null) {
      try {
        _logFile!.writeAsStringSync(logLine, mode: FileMode.append, flush: true);
      } catch (e) {
        debugPrint('Log write error: $e');
      }
    }
  }

  static Future<void> clearLog() async {
    if (_logFile == null) {
      debugPrint('[LogService] clearLog: _logFile is null — skipping.');
      return;
    }

    _isCleaning = true;

    try {
      if (await _logFile!.exists()) {
        await _logFile!.writeAsString(''); // очищення
        debugPrint('[LogService] Log cleared.');
      }
    } catch (e) {
      debugPrint('[LogService] Failed to clear log: $e');
    } finally {
      _isCleaning = false;

      // записати все, що накопичилось під час очищення
      if (_queuedLogs.isNotEmpty) {
        try {
          await _logFile!.writeAsString(_queuedLogs.join(), mode: FileMode.append);
        } catch (e) {
          debugPrint('Log flush error: $e');
        }
        _queuedLogs.clear();
      }

      // ✅ Сигнальний рядок
      try {
        await _logFile!.writeAsString('[LogService] ✅ LOG CLEAR COMPLETE\n', mode: FileMode.append);
      } catch (e) {
        debugPrint('Log signal error: $e');
      }
    }
  }

  static Future<void> clearIfTooBig() async {
    if (_logFile == null) return;

    try {
      final length = await _logFile!.length();
      if (length > 5 * 1024 * 1024) {
        await clearLog();
        debugPrint('[LogService] Log auto-cleared (too big)');
      }
    } catch (e) {
      debugPrint('[LogService] Failed to check log size: $e');
    }
  }

  /// Отримати шлях до лог-файлу
  static String? getLogFilePath() {
    return _logFile?.path;
  }

  /// Прочитати вміст лог-файлу
  static Future<String?> readLogFile() async {
    if (_logFile == null) return null;

    try {
      if (await _logFile!.exists()) {
        return await _logFile!.readAsString();
      }
    } catch (e) {
      debugPrint('[LogService] Failed to read log file: $e');
    }
    return null;
  }
}
