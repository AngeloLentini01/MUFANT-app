import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'app_text_indexer.dart';

/// Provides fuzzy search functionality over the indexed app text.
class AppTextSearch {
  /// Returns a list of matches with their scores and file locations.
  static List<Map<String, dynamic>> search(
    String query, {
    int limit = 10,
    int threshold = 35, // Lowered for typo tolerance
  }) {
    final indexer = AppTextIndexer();
    final results = <Map<String, dynamic>>[];
    final lowerQuery = query.toLowerCase();
    for (final entry in indexer.textMap.entries) {
      final keyLower = entry.key.toLowerCase();
      // Use multiple fuzzywuzzy algorithms for better typo tolerance
      int score1 = ratio(keyLower, lowerQuery);
      int score2 = partialRatio(keyLower, lowerQuery);
      int score3 = tokenSortRatio(keyLower, lowerQuery);
      int score = [score1, score2, score3].reduce((a, b) => a > b ? a : b);
      // If the query is a substring (infix) of the text, boost the score or always include
      if (keyLower.contains(lowerQuery)) {
        score = (keyLower == lowerQuery) ? 100 : 90;
      }
      if (score >= threshold) {
        results.add({'text': entry.key, 'score': score, 'file': entry.value});
      }
    }
    results.sort((a, b) => b['score'].compareTo(a['score']));
    return results.take(limit).toList();
  }
}
