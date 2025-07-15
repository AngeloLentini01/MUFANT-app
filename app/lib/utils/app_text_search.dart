import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'app_text_indexer.dart';

/// Provides fuzzy search functionality over the indexed app text.
class AppTextSearch {
  /// Returns a list of matches with their scores and file locations.
  static List<Map<String, dynamic>> search(
    String query, {
    int limit = 10,
    int threshold = 60,
  }) {
    final indexer = AppTextIndexer();
    final results = <Map<String, dynamic>>[];
    for (final entry in indexer.textMap.entries) {
      final score = ratio(entry.key, query);
      if (score >= threshold) {
        results.add({'text': entry.key, 'score': score, 'file': entry.value});
      }
    }
    results.sort((a, b) => b['score'].compareTo(a['score']));
    return results.take(limit).toList();
  }
}
