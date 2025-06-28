import 'package:app/model/generic/details_model.dart';
import 'package:app/presentation/widgets/scrollViews/items/event_card.dart';
import 'package:flutter/material.dart';

class CustomListWidget extends StatelessWidget {
  const CustomListWidget({
    super.key,
    required this.title,
    required this.textColor,
    required this.activities,
  });

  final String title;
  final Color textColor;
  final List<DetailsModel> activities;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: activities
                  .map(
                    (event) => EventCard(
                      imagePath: event.imageUrlOrPath ?? '',
                      title: event.name,
                      info: event.notes ?? '',
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
