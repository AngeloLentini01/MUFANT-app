import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/spacing/visitors_guide.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class VisitorsGuideWidget extends StatelessWidget {
  const VisitorsGuideWidget({super.key, required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'visitors_guide'.tr(),
          style: kSectionTitleTextStyle,
        ),
        kSpaceBetweenVisitorsGuideTitleAndTimeTable,
        Row(
          children: [
            Icon(Icons.access_time, color: textColor),
            const SizedBox(width: 8),
            Text(
              'opening_hours'.tr(),
              style: const TextStyle(
                color: kWhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        kSpaceBetweenVisitorsGuideDetailsTitleAndDates,
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
                      'mon_wed'.tr(),
                      style: const TextStyle(
                        color: kWhiteColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'closed'.tr(),
                      style: const TextStyle(
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
                      'thu_sun'.tr(),
                      style: const TextStyle(
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
              'where_to_reach_us'.tr(),
              style: const TextStyle(
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
            'Piazza Riccardo Valla, 5, 10148 Torino TO',
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
