import 'package:flutter/material.dart';
import 'dart:math';
import 'package:app/presentation/services/badWords/bad_words.dart';

class BadWordsFilterService {
  static final BadWordsFilterService _instance =
      BadWordsFilterService._internal();
  factory BadWordsFilterService() => _instance;
  BadWordsFilterService._internal();

  // Simple whitelist for common legitimate words
  static final Set<String> _whitelist = {
    'password',
    'passwords',
    'passport',
    'passage',
    'passenger',
    'passion',
    'passionate',
    'assistant',
    'assignment',
    'associate',
    'association',
    'assume',
    'assumption',
    'class',
    'classic',
    'classical',
    'classification',
    'classified',
    'grass',
    'glass',
    'mass',
    'bass',
    'brass',
    'assess',
    'butter',
    'button',
    'butterfly',
    'buttercup',
    'hell',
    'hello',
    'help',
    'helpful',
    'helpless',
    'damn',
    'damage',
    'damaged',
    'damaging',
    'shit',
    'shift',
    'ship',
    'shirt',
    'shirtless',
  };

  // Comprehensive list of bad words in multiple languages

  // Leet/typo normalization map
  static final Map<String, String> _leetMap = {
    '0': 'o',
    '1': 'i',
    '3': 'e',
    '4': 'a',
    '5': 's',
    '7': 't',
    '@': 'a',
    '\$': 's',
    '!': 'i',
    '|': 'i',
    '+': 't',
    '€': 'e',
    '£': 'l',
  };

  String _normalize(String input) {
    var out = input.toLowerCase();
    _leetMap.forEach((k, v) {
      out = out.replaceAll(k, v);
    });
    return out;
  }

  // Levenshtein distance (edit distance)
  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;
    List<List<int>> d = List.generate(
      s.length + 1,
      (_) => List.filled(t.length + 1, 0),
    );
    for (int i = 0; i <= s.length; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= t.length; j++) {
      d[0][j] = j;
    }
    for (int i = 1; i <= s.length; i++) {
      for (int j = 1; j <= t.length; j++) {
        int cost = s[i - 1] == t[j - 1] ? 0 : 1;
        d[i][j] = [
          d[i - 1][j] + 1,
          d[i][j - 1] + 1,
          d[i - 1][j - 1] + cost,
        ].reduce(min);
      }
    }
    return d[s.length][t.length];
  }

  /// Initialize the filter with supported languages
  Future<void> initialize() async {
    // No initialization needed for simple implementation
  }

  /// Check if text contains bad words (typo-resistant)
  Future<bool> containsBadWords(String text) async {
    if (text.trim().isEmpty) return false;
    final normalizedText = _normalize(text);
    final words = normalizedText.split(RegExp(r'[^a-zA-Z0-9]+'));

    for (final badWord in badWords) {
      final normBad = _normalize(badWord);

      // Check for exact, substring match
      if (normalizedText.contains(normBad)) {
        // Check if the matched word is in the whitelist
        if (_whitelist.contains(normBad)) continue;

        // Check if the bad word is part of a whitelisted word
        bool isPartOfWhitelistedWord = false;
        for (final whitelistedWord in _whitelist) {
          if (whitelistedWord.contains(normBad)) {
            isPartOfWhitelistedWord = true;
            break;
          }
        }
        if (isPartOfWhitelistedWord) continue;

        print('DEBUG: Flagged word $normBad in text$normalizedText');
        return true;
      }

      // Only do fuzzy matching for words longer than 6 characters (increased from 4)
      for (final word in words) {
        if (word.isEmpty || word.length < 6) continue;
        if (normBad.length < 6) continue;

        // Skip if word is in whitelist
        if (_whitelist.contains(word)) continue;

        final distance = _levenshtein(word, normBad);
        // More conservative distance calculation - only allow 1 character difference for longer words
        final maxDistance = word.length > 8 ? 1 : (word.length / 5).floor();
        if (distance <= maxDistance) {
          print(
            'DEBUG: Fuzzy matched word "$word" to bad word "$normBad" with distance $distance',
          );
          return true;
        }
      }
    }
    return false;
  }

  /// Get the list of bad words found in the text (typo-resistant)
  Future<List<String>> getBadWords(String text) async {
    if (text.trim().isEmpty) return [];
    final normalizedText = _normalize(text);
    final words = normalizedText.split(RegExp(r'[^a-zA-Z0-9]+'));
    final foundBadWords = <String>[];
    for (final badWord in badWords) {
      final normBad = _normalize(badWord);

      if (normalizedText.contains(normBad)) {
        // Check if the matched word is in the whitelist
        if (_whitelist.contains(normBad)) continue;

        // Check if the bad word is part of a whitelisted word
        bool isPartOfWhitelistedWord = false;
        for (final whitelistedWord in _whitelist) {
          if (whitelistedWord.contains(normBad)) {
            isPartOfWhitelistedWord = true;
            break;
          }
        }
        if (isPartOfWhitelistedWord) continue;

        foundBadWords.add(badWord);
        continue;
      }

      for (final word in words) {
        if (word.isEmpty || word.length < 6) continue;
        if (normBad.length < 6) continue;

        // Skip if word is in whitelist
        if (_whitelist.contains(word)) continue;

        final distance = _levenshtein(word, normBad);
        // More conservative distance calculation - only allow 1 character difference for longer words
        final maxDistance = word.length > 8 ? 1 : (word.length / 5).floor();
        if (distance <= maxDistance) {
          foundBadWords.add(badWord);
          break;
        }
      }
    }
    return foundBadWords;
  }

  /// Show bad words alert dialog
  void showBadWordsAlert(BuildContext context, List<String> badWords) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Inappropriate Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your input contains inappropriate words that are not allowed:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badWords.join(', '),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please use appropriate language and try again.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
