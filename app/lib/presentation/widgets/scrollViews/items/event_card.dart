import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.info,
    this.onTap,
  });

  final String imagePath;
  final String title;
  final String info;
  final VoidCallback? onTap;

  /// Extract text after the second carriage return/line feed
  String _extractBadgeText() {
    // Regex to match text after the first \r\n or \n
    final regex = RegExp(r'(?:\r?\n)(.*?)(?:\r?\n|$)', dotAll: true);
    final match = regex.firstMatch(info);

    if (match != null && match.group(1) != null) {
      return match.group(1)!.trim();
    }

    // Fallback: if no line break found, check for "Ingresso gratuito"
    if (info.toLowerCase().contains('ingresso gratuito')) {
      return 'Ingresso gratuito';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 172, // Slightly wider to accommodate text
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Container(
              width: 160,
              height: 160, // Maintain poster aspect ratio
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Check if there's badge text to show overlay
                  if (_extractBadgeText().isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: kBlackColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _extractBadgeText(),
                          style: const TextStyle(
                            color: kWhiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Title below the image
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (info.isNotEmpty) ...[
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: info
                            .replaceAll(_extractBadgeText(), '')
                            .replaceAll('Ingresso gratuito', '')
                            .replaceAll('\n\n', '\n')
                            .trim(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ],
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
