import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:ticket_material/ticket_material.dart';

/// Reusable ticket widget using TicketMaterial
class MyTicketWidget extends StatelessWidget {
  final String eventDate;
  final String eventTime;
  final String eventTitle;
  final String venueAddress;

  const MyTicketWidget({
    super.key,
    required this.eventDate,
    required this.eventTime,
    required this.eventTitle,
    required this.venueAddress,
  });

  @override
  Widget build(BuildContext context) {
    return TicketMaterial(
      height: 150,
      colorBackground: const Color(
        0xFFB8B5D1,
      ), // Colore grigio-lavanda come Ticket.png
      radiusBorder: 12,
      leftChild: _buildLeft(),
      rightChild: _buildRight(),
    );
  }

  Widget _buildLeft() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Top row: Date and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                eventDate,
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                eventTime,
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // Center: Event title in uppercase bold
          Text(
            eventTitle.toUpperCase(),
            style: const TextStyle(
              color: kBlackColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Bottom: Location with icon
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: kBlackColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  venueAddress,
                  style: const TextStyle(
                    color: kBlackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRight() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: AssetImage('assets/images/ticket/barcode-ticket.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

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

        // Using the new MyTicketWidget with TicketMaterial
        MyTicketWidget(
          eventDate: eventDate,
          eventTime: eventTime,
          eventTitle: eventName,
          venueAddress: eventLocation,
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
