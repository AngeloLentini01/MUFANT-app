import 'package:flutter/material.dart';
import 'package:app/presentation/widgets/all.dart';

/// Abstract interface for searchable items
abstract class SearchableItem {
  String get id;
  String get title;
  String get subtitle;
  String get category;
  String get searchableText;
}

/// Search result model
class SearchResult<T extends SearchableItem> {
  final T item;
  final String matchedText;
  final double relevanceScore;
  final String category;

  SearchResult({
    required this.item,
    required this.matchedText,
    required this.relevanceScore,
    required this.category,
  });
}

/// Abstract search strategy interface
abstract class SearchStrategy {
  List<SearchResult<T>> search<T extends SearchableItem>(
    String query,
    List<T> items,
  );
}

/// Simple text-based search strategy
class TextSearchStrategy implements SearchStrategy {
  @override
  List<SearchResult<T>> search<T extends SearchableItem>(
    String query,
    List<T> items,
  ) {
    if (query.trim().isEmpty) return [];

    final searchTerm = query.trim().toLowerCase();
    final results = <SearchResult<T>>[];

    for (final item in items) {
      final searchableText = item.searchableText.toLowerCase();
      final title = item.title.toLowerCase();
      final subtitle = item.subtitle.toLowerCase();

      // Check for exact matches first
      if (title == searchTerm) {
        results.add(
          SearchResult<T>(
            item: item,
            matchedText: item.title,
            relevanceScore: 100.0,
            category: item.category,
          ),
        );
        continue;
      }

      // Check for title starts with
      if (title.startsWith(searchTerm)) {
        results.add(
          SearchResult<T>(
            item: item,
            matchedText: item.title,
            relevanceScore: 90.0,
            category: item.category,
          ),
        );
        continue;
      }

      // Check for contains in title
      if (title.contains(searchTerm)) {
        results.add(
          SearchResult<T>(
            item: item,
            matchedText: item.title,
            relevanceScore: 80.0,
            category: item.category,
          ),
        );
        continue;
      }

      // Check for contains in subtitle
      if (subtitle.contains(searchTerm)) {
        results.add(
          SearchResult<T>(
            item: item,
            matchedText: item.subtitle,
            relevanceScore: 70.0,
            category: item.category,
          ),
        );
        continue;
      }

      // Check for contains in searchable text
      if (searchableText.contains(searchTerm)) {
        results.add(
          SearchResult<T>(
            item: item,
            matchedText: item.title,
            relevanceScore: 60.0,
            category: item.category,
          ),
        );
      }
    }

    // Sort by relevance score
    results.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return results;
  }
}

/// Search service that manages search operations
class SearchService {
  final SearchStrategy _strategy;

  SearchService({SearchStrategy? strategy})
    : _strategy = strategy ?? TextSearchStrategy();

  /// Search through a list of items
  List<SearchResult<T>> search<T extends SearchableItem>(
    String query,
    List<T> items, {
    int maxResults = 10,
  }) {
    final results = _strategy.search(query, items);
    return results.take(maxResults).toList();
  }

  /// Get the best matching substring for highlighting
  String getBestMatch(String originalText, String searchTerm) {
    final originalLower = originalText.toLowerCase();
    final searchLower = searchTerm.toLowerCase();

    if (originalLower.contains(searchLower)) {
      final startIndex = originalLower.indexOf(searchLower);
      return originalText.substring(startIndex, startIndex + searchTerm.length);
    }

    // Try to find the longest common substring
    final words = searchLower.split(' ');
    for (final word in words) {
      if (word.length > 2 && originalLower.contains(word)) {
        final wordIndex = originalLower.indexOf(word);
        return originalText.substring(wordIndex, wordIndex + word.length);
      }
    }

    return searchTerm;
  }
}

/// Search dialog widget
class SearchDialog<T extends SearchableItem> extends StatefulWidget {
  final String title;
  final List<T> items;
  final SearchService searchService;
  final Function(T item, String matchedText) onItemSelected;
  final String? hintText;

  const SearchDialog({
    super.key,
    required this.title,
    required this.items,
    required this.searchService,
    required this.onItemSelected,
    this.hintText,
  });

  @override
  State<SearchDialog<T>> createState() => _SearchDialogState<T>();
}

class _SearchDialogState<T extends SearchableItem>
    extends State<SearchDialog<T>> {
  final TextEditingController _controller = TextEditingController();
  List<SearchResult<T>> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _results = widget.searchService.search(value, widget.items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          fontSize: 16,
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilteredTextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Type here to search...',
                hintStyle: const TextStyle(color: Colors.white54),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 16),
            if (_results.isEmpty && _controller.text.isNotEmpty)
              const Text(
                'No results found.',
                style: TextStyle(color: Colors.white54),
              ),
            if (_results.isNotEmpty)
              Flexible(
                child: SizedBox(
                  width: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _results.length,
                    itemBuilder: (context, idx) {
                      final result = _results[idx];
                      return ListTile(
                        title: Text(
                          result.item.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.item.subtitle,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              result.category,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.white38,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onItemSelected(
                            result.item,
                            result.matchedText,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
