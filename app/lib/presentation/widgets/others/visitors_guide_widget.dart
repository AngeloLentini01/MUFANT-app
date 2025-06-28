import 'package:app/presentation/styles/colors/generic.dart';
import 'package:flutter/material.dart';

class VisitorsGuideWidget extends StatelessWidget {
  const VisitorsGuideWidget({super.key, required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visitor\'s Guide',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.access_time, color: textColor),
            const SizedBox(width: 8),
            Text(
              'Opening hours',
              style: TextStyle(
                color: kWhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Mon - Wed',
                      style: TextStyle(
                        color: kWhiteColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Closed',
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Thu - Sun',
                      style: TextStyle(
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '15.30 - 19.00',
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.location_on, color: textColor),
            const SizedBox(width: 8),
            Text(
              'Where to reach us',
              style: TextStyle(
                color: kWhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            'P.za Riccardo Valla, 5, 10148 Torino TO',
            style: TextStyle(
              color: kWhiteColor,
              decoration: TextDecoration.none,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
