import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/styles/spacing/section.dart';
import 'package:app/presentation/widgets/scrollViews/items/event_card.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/utils/app_logger.dart';
import 'package:logging/logging.dart';

class CustomListWidget extends StatelessWidget {
  const CustomListWidget({
    super.key,
    required this.title,
    required this.textColor,
    required this.activities,
    this.onItemTap,
    this.getEventPrice,
  });

  final String title;
  final Color textColor;
  final List<DetailsModel> activities;
  final Function(DetailsModel)? onItemTap;
  final double Function(DetailsModel)? getEventPrice;

  static final Logger _logger = AppLogger.getLogger('CustomListWidget');

  String getOverlayKey(String notes) {
    final lower = notes.trim().toLowerCase();
    if (lower.contains('free entry') || lower.contains('ingresso gratuito')) {
      return 'free_entry';
    }
    if (lower.contains('coming soon') || lower.contains('prossimamente')) {
      return 'coming_soon';
    }
    if (lower.contains('starting from')) {
      return 'starting_from_price';
    }
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kSectionTitleTextStyle),
        kBlankSpaceInSectionBetweenTitleAndList,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: activities.map((event) {
              String info;
              String desc = (event.description ?? '').trim();
              if ((event.notes ?? '').contains('1st floor')) {
                info = 'first_floor'.tr();
              } else if ((event.notes ?? '').contains('2nd floor')) {
                info = 'second_floor'.tr();
              } else if (desc == '1st floor') {
                info = 'first_floor'.tr();
              } else if (desc == '2nd floor') {
                info = 'second_floor'.tr();
              } else if (desc.isNotEmpty) {
                info = desc.tr();
              } else {
                info = '';
              }
              AppLogger.debug(
                _logger,
                'ROOM DEBUG: name=${event.name}, notes=${event.notes}, description=${event.description}, locale=${context.locale}, info=$info',
              );
              return EventCard(
                imagePath: event.imageUrlOrPath ?? '',
                title: event.name.isNotEmpty ? event.name.tr() : '',
                info: info,
                overlay: (() {
                  final notes = event.notes ?? '';
                  if (notes.trim().toLowerCase().startsWith('starting_from')) {
                    // Estraggo il prezzo dopo 'starting_from'
                    final priceMatch = RegExp(
                      r'starting_from\s*(\d+[\.,]?\d*)',
                    ).firstMatch(notes);
                    String priceStr = '€?';
                    if (priceMatch != null && priceMatch.group(1) != null) {
                      priceStr =
                          '€${priceMatch.group(1)!.replaceAll(',', '.')}';
                    }
                    return 'starting_from_price'.tr(
                      namedArgs: {'price': priceStr},
                    );
                  } else if (notes.isNotEmpty) {
                    return notes.tr();
                  } else {
                    return '';
                  }
                })(),
                onTap: onItemTap != null ? () => onItemTap!(event) : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
