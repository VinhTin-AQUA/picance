import 'dart:io';

class LogService {
  static final String _logPath = 'logs/app_log.txt';
  static late final File _logFile;
  static bool _initialized = false;

  /// Gọi hàm này 1 lần trong `main()` để chuẩn bị log file
  static Future<void> init() async {
    if (_initialized) return;

    _logFile = File(_logPath);
    if (!await _logFile.exists()) {
      await _logFile.create(recursive: true);
    }
    _initialized = true;
  }

  static Future<void> writeLog(String message) async {
    if (!_initialized) await init();

    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] $message\n';
    await _logFile.writeAsString(logEntry, mode: FileMode.append);
  }

  static Future<String> readLogs() async {
    if (!_initialized) await init();
    return await _logFile.readAsString();
  }

  static Future<void> clearLogs() async {
    if (!_initialized) await init();
    await _logFile.writeAsString('');
  }
}
