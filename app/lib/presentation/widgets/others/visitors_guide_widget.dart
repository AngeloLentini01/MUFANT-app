import 'package:flutter/material.dart';

class VisitorsGuideWidget extends StatelessWidget {
  const VisitorsGuideWidget({
    super.key,
    required this.textColor,
  });

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
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(left: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Mon - Wed',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text('Closed', style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Thu - Sun',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text('15.30 - 19.00', style: TextStyle(color: Colors.white)),
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
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(left: 32.0),
          child: Text(
            'P.za Riccardo Valla, 5, 10148 Torino TO',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
