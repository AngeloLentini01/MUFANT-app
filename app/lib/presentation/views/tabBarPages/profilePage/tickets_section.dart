import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';

class TicketsSection extends StatelessWidget {
  const TicketsSection({super.key});

  // Dynamic ticket content variables
  final String eventDate = '29, May 2025';
  final String eventTime = '15:30 - 19:00';
  final String eventName = '30 ANNI DI SAILOR';
  final String eventLocation = 'piazza Riccardo Valle 5, Torino';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text('My tickets', style: kSectionTitleTextStyle),

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
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: kBlackColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/images/ticket/Ticket.png'),
              fit: BoxFit.cover,
            ),
          ),

          child: Row(
            children: [
              // Barcode
              Transform.translate(
                offset: const Offset(-8, 0), // Sposta 8 pixel verso sinistra
                child: Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/ticket/barcode-ticket.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date and time on the same line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          eventDate,
                          style: TextStyle(color: kBlackColor, fontSize: 14),
                        ),
                        Text(
                          eventTime,
                          style: TextStyle(color: kBlackColor, fontSize: 12),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      eventName,
                      style: TextStyle(
                        color: kBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      eventLocation,
                      style: TextStyle(color: kBlackColor, fontSize: 12),
                    ),
                  ],
                ),
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
