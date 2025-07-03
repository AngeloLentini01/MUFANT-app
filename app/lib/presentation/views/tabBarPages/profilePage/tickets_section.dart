import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';

class TicketsSection extends StatelessWidget {
  const TicketsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              'My tickets',

              style: kSectionTitleTextStyle,
            ),

            TextButton(
              onPressed: () {
                // TODO: Navigate to all tickets
              },

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: const [
                  Text(
                    'See all',

                    style: TextStyle(color: lightGreyColor, fontSize: 16),
                  ),

                  SizedBox(width: 4),

                  Icon(
                    Icons.arrow_forward_ios,

                    color: lightGreyColor,

                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: greyColor,

            borderRadius: BorderRadius.circular(16),

            boxShadow: [
              BoxShadow(
                color: kBlackColor.withValues(alpha: 0.2),

                blurRadius: 8,

                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              // Barcode
              Container(
                width: 60,

                height: 80,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(8),
                ),

                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: Colors.black,

                          borderRadius: BorderRadius.circular(4),
                        ),

                        child: Column(
                          children: List.generate(
                            15,
                            (index) => Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 1),

                                color: index % 2 == 0
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      '29, May 2025',

                      style: TextStyle(color: lightGreyColor, fontSize: 14),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      '30 ANNI DI SAILOR',

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 16,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'piazza Riccardo Valle 5, Torino',

                      style: TextStyle(color: lightGreyColor, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const Text(
                '15:30 - 19:00',

                style: TextStyle(color: lightGreyColor, fontSize: 12),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Center(
          child: TextButton(
            onPressed: () {
              // TODO: Show ticket details
            },

            child: const Text(
              'View Details',

              style: TextStyle(color: lightGreyColor, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
