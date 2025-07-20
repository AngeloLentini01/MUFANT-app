import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/styles/spacing/section.dart';
import 'package:app/presentation/widgets/scrollViews/items/event_card.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomListWidget extends StatelessWidget {
  const CustomListWidget({
    super.key,
    required this.title,
    required this.textColor,
    required this.activities,
    this.onItemTap,
  });

  final String title;
  final Color textColor;
  final List<DetailsModel> activities;
  final Function(DetailsModel)? onItemTap;

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
            children: activities
                .map(
                  (event) => EventCard(
                    imagePath: event.imageUrlOrPath ?? '',
                    title: event.name.isNotEmpty ? event.name.tr() : '',
                    info: (event.description ?? '').isNotEmpty
                        ? event.description!.tr()
                        : '',
                    overlay: (event.notes ?? '').isNotEmpty
                        ? event.notes!.tr()
                        : '',
                    onTap: onItemTap != null ? () => onItemTap!(event) : null,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
