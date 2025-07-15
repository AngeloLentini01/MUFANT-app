import 'dart:collection';
import 'dart:io';

/// Singleton class to extract and index all text strings in the app.
class AppTextIndexer {
  static final AppTextIndexer _instance = AppTextIndexer._internal();
  factory AppTextIndexer() => _instance;
  AppTextIndexer._internal();

  final HashMap<String, String> _textMap = HashMap();
  bool _initialized = false;

  /// Call this once at app startup.
  Future<void> initialize() async {
    if (_initialized) return;
    // For demonstration, scan only the lib/ directory for .dart files
    final dir = Directory('lib');
    if (!dir.existsSync()) return;
    final files = dir
        .listSync(recursive: true)
        .where((f) => f.path.endsWith('.dart'));
    for (final file in files) {
      final content = await File(file.path).readAsString();
      // Simple regex to extract text in double or single quotes
      final regex = RegExp(r'(["\"]).*?\1');
      for (final match in regex.allMatches(content)) {
        final text = match.group(0);
        if (text != null && text.length > 2) {
          // Remove quotes
          final clean = text.substring(1, text.length - 1);
          if (clean.trim().isNotEmpty) {
            _textMap[clean] = file.path;
          }
        }
      }
    }
    _initialized = true;
  }

  HashMap<String, String> get textMap => _textMap;
}
