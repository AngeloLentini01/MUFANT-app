import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/services/search_service.dart';

class ShopEventItem implements SearchableItem {
  @override
  final String id;
  @override
  final String title;
  @override
  final String subtitle;
  final double price;
  @override
  final String category;
  final String imageAsset;

  ShopEventItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.category,
    required this.imageAsset,
  });

  factory ShopEventItem.fromDetailsModel(DetailsModel model) {
    double price = 0.0;
    // Prefer price after 'MUFANT ticket' or 'Biglietto MUFANT', else fallback to first price
    if (model.notes != null && model.notes!.isNotEmpty) {
      final generalTicketRegex = RegExp(
        r'(?:MUFANT ticket|Biglietto MUFANT)[^\d€]*€\s?(\d+[\.,]?\d*)',
        caseSensitive: false,
      );
      final generalMatch = generalTicketRegex.firstMatch(model.notes!);
      if (generalMatch != null && generalMatch.group(1) != null) {
        price =
            double.tryParse(generalMatch.group(1)!.replaceAll(',', '.')) ?? 0.0;
      } else {
        final priceMatch = RegExp(
          r'\b(\d+[\.,]?\d*)\s*€|€\s*(\d+[\.,]?\d*)',
        ).firstMatch(model.notes!);
        if (priceMatch != null) {
          final priceStr = priceMatch.group(1) ?? priceMatch.group(2);
          if (priceStr != null) {
            price = double.tryParse(priceStr.replaceAll(',', '.')) ?? 0.0;
          }
        }
      }
    }
    // Hardcoded price fallback for known events
    final lowerName = model.name.toLowerCase();
    if (lowerName.contains('artificial prophecies')) {
      price = 20.0;
    } else if (lowerName.contains('ufo pop')) {
      price = 20.0;
    } else if (lowerName.contains("sailor moon")) {
      price = 0.0;
    }
    // Use model.id if present and not empty, otherwise fallback to event name with 'event_' prefix for uniqueness
    String eventId =
        (model.id?.toString() != null && model.id.toString().isNotEmpty)
        ? model.id.toString()
        : 'event_${model.name}';
    return ShopEventItem(
      id: eventId,
      title: model.name,
      subtitle: model.description ?? '',
      price: price,
      category: 'Events',
      imageAsset: model.imageUrlOrPath ?? '',
    );
  }

  @override
  String get searchableText => '$title $subtitle $category';
}
