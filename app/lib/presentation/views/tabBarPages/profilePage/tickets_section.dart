import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:ticket_material/ticket_material.dart';

/// Custom painter for creating a barcode pattern
class BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Generate barcode pattern with varying widths
    final barWidths = [2.0, 1.0, 3.0, 1.0, 2.0, 1.0, 1.0, 2.0, 3.0, 1.0, 2.0, 1.0, 1.0, 3.0, 2.0, 1.0, 2.0, 1.0, 3.0, 1.0, 2.0, 1.0, 1.0, 2.0, 3.0, 1.0, 2.0, 1.0, 1.0, 3.0, 2.0, 1.0, 3.0, 1.0, 2.0];
    
    // Calculate total width needed and scale factor
    double totalBarsWidth = barWidths.reduce((a, b) => a + b);
    double totalSpacing = (barWidths.length - 1) * 1.0; // 1px spacing between bars
    double totalNeededWidth = totalBarsWidth + totalSpacing;
    double scaleFactor = size.width / totalNeededWidth;
    
    double currentX = 0;
    const double barHeight = 40;
    const double spacing = 1.0;

    for (int i = 0; i < barWidths.length; i++) {
      final barWidth = barWidths[i] * scaleFactor;
      
      // Draw black bar
      canvas.drawRect(
        Rect.fromLTWH(currentX, (size.height - barHeight) / 2, barWidth, barHeight),
        paint,
      );
      
      currentX += barWidth + (spacing * scaleFactor);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Reusable ticket widget using TicketMaterial
/// TODO: Rendere questo widget più flessibile per supportare diversi tipi di biglietti
/// TODO: Aggiungere supporto per biglietti scaduti (diversa visualizzazione)
/// TODO: Implementare QR code dinamico al posto del barcode statico
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
      tapHandler: () => _showTicketDetails(context),
    );
  }

  /// Shows full-screen ticket details overlay
  void _showTicketDetails(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Ticket Details',
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 400,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFA5A0BE), // A5A0BE senza trasparenza
                  Color(0xFFF2BFE3), // F2BFE3 senza trasparenza
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main ticket details content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with close button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ticket Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kBlackColor,
                              decoration: TextDecoration.none, // Rimuove linee gialle
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, color: kBlackColor),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Event title
                      Text(
                        eventTitle.toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kBlackColor,
                          decoration: TextDecoration.none, // Rimuove linee gialle
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date and time
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: kBlackColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            eventDate,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kBlackColor,
                              decoration: TextDecoration.none, // Rimuove linee gialle
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.access_time,
                            size: 20,
                            color: kBlackColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            eventTime,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kBlackColor,
                              decoration: TextDecoration.none, // Rimuove linee gialle
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 20,
                            color: kBlackColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              venueAddress,
                              style: TextStyle(
                                fontSize: 16,
                                color: kBlackColor,
                                decoration: TextDecoration.none, // Rimuove linee gialle
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Bottom barcode section
                      Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 48), // 48px dai bordi
                            child: CustomPaint(
                              painter: BarcodePainter(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      },
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
  // TODO: Implementare logica per recuperare l'ultimo biglietto acquistato dal database/API
  // TODO: Sostituire questi valori hardcoded con dati dinamici provenienti dal backend
  // TODO: Aggiungere listener per aggiornamenti real-time quando viene acquistato un nuovo biglietto
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
        // TODO: Integrare con sistema di gestione biglietti per mostrare l'ultimo acquistato
        // TODO: Aggiungere stato di caricamento mentre si recuperano i dati del biglietto
        // TODO: Gestire caso in cui l'utente non ha biglietti (mostrare placeholder o messaggio)
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
              // Show the same ticket details modal as the ticket tap
              MyTicketWidget(
                eventDate: eventDate,
                eventTime: eventTime,
                eventTitle: eventName,
                venueAddress: eventLocation,
              )._showTicketDetails(context);
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
