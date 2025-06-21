import 'package:app/presentation/components/scrollViews/items/event_card.dart';
import 'package:flutter/material.dart';

class UpcomingEventsWidget extends StatelessWidget {
  const UpcomingEventsWidget({super.key, required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UPCOMING EVENTS',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            // Changed from Wrap to Row
            children: [
              EventCard(imagePath: 'assets/images/locandine/sailor-moon.jpg'),
              const SizedBox(width: 12), // Explicit spacing
              EventCard(imagePath: 'assets/images/locandine/locandina1.png'),
              const SizedBox(width: 12), // Explicit spacing
              EventCard(
                imagePath: 'assets/images/locandine/profezie-artificiali.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
