import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/services/search_service.dart';
import 'package:easy_localization/easy_localization.dart';

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
  final String originalName;

  ShopEventItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.category,
    required this.imageAsset,
    required this.originalName,
  });

  static String getEventTitleKey(String dbName) {
    switch (dbName.trim().toLowerCase()) {
      case "sailor moon's anniversary":
      case "30 anni di sailor":
        return 'event_sailor_anniversary';
      case "artificial prophecies":
      case "profezie artificiali":
        return 'event_artificial_prophecies';
      case "ufo pop":
        return 'event_ufo_pop';
      // Add more mappings as needed
      default:
        return dbName; // fallback to raw name if no mapping exists
    }
  }

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
    final titleKey = getEventTitleKey(model.name);
    return ShopEventItem(
      id: eventId,
      title: titleKey == model.name ? model.name : titleKey.tr(),
      subtitle: model.description ?? '',
      price: price,
      category: 'events'.tr(),
      imageAsset: model.imageUrlOrPath ?? '',
      originalName: model.originalName ?? model.name,
    );
  }

  @override
  String get searchableText => '$title $subtitle $category $originalName';
}
