import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/styles/typography/section.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:ticket_material/ticket_material.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/ticketList/ticket_list_page.dart';
import 'package:app/data/services/ticket_service.dart';
import 'package:app/model/items/ticket/ticket_display_data.dart';
import 'package:barcode/barcode.dart';
import 'package:app/utils/app_logger.dart';
import 'package:logging/logging.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/main.dart' show appMainKey;

/// Custom painter for creating a barcode using the barcode library
class BarcodePainter extends CustomPainter {
  final String data;

  const BarcodePainter({this.data = "MUFANT-TICKET-123456789"});

  @override
  void paint(Canvas canvas, Size size) {
    final bc = Barcode.code128();

    try {
      // Generate barcode elements
      final barcodeElements = bc.make(
        data,
        width: size.width,
        height: size.height,
      );

      final paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      // Draw barcode elements
      for (final element in barcodeElements) {
        if (element is BarcodeBar && element.black) {
          canvas.drawRect(
            Rect.fromLTWH(
              element.left,
              element.top,
              element.width,
              element.height,
            ),
            paint,
          );
        }
      }
    } catch (e) {
      // Fallback: draw a simple pattern if barcode generation fails
      _drawFallbackPattern(canvas, size);
    }
  }

  void _drawFallbackPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Simple barcode-like pattern as fallback
    final barCount = 20;
    final barWidth = size.width / (barCount * 2);

    for (int i = 0; i < barCount; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(
          Rect.fromLTWH(i * barWidth * 2, 0, barWidth, size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Reusable barcode widget
class BarcodeWidget extends StatelessWidget {
  final String data;
  final double? width;
  final double? height;

  const BarcodeWidget({super.key, required this.data, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 40,
      child: CustomPaint(painter: BarcodePainter(data: data)),
    );
  }
}

/// Reusable ticket widget using TicketMaterial
/// TODO: Rendere questo widget più flessibile per supportare diversi tipi di biglietti
/// TODO: Aggiungere supporto per biglietti scaduti (diversa visualizzazione)
/// ✅ COMPLETED: Implementato barcode dinamico utilizzando la libreria barcode (sia orizzontale che verticale, senza background)
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
      barrierLabel: 'ticket_details'.tr(),
      barrierColor: Colors.black.withValues(alpha: 0.5),
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
                  color: Colors.black.withValues(alpha: 0.2),
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
                            'ticket_details'.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kBlackColor,
                              decoration:
                                  TextDecoration.none, // Rimuove linee gialle
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
                          decoration:
                              TextDecoration.none, // Rimuove linee gialle
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date
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
                              decoration:
                                  TextDecoration.none, // Rimuove linee gialle
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Time
                      Row(
                        children: [
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
                              decoration:
                                  TextDecoration.none, // Rimuove linee gialle
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
                                decoration:
                                    TextDecoration.none, // Rimuove linee gialle
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
                            margin: const EdgeInsets.symmetric(
                              horizontal: 48,
                            ), // 48px dai bordi
                            child: BarcodeWidget(
                              data:
                                  "MUFANT-${eventTitle.replaceAll(' ', '').toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}",
                              width: double.infinity,
                              height: 40,
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
      padding: const EdgeInsets.all(6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calcola dimensioni più generose ma sicure
          final availableWidth = constraints.maxWidth - 2; // Margine minimo
          final availableHeight = constraints.maxHeight - 2;

          return Center(
            child: VerticalBarcodeWidget(
              data:
                  "MUFANT-SIDE-${eventTitle.replaceAll(' ', '').toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}",
              width: (availableWidth * 0.85).clamp(
                45.0,
                70.0,
              ), // Aumentato: 45-70px
              height: (availableHeight * 0.85).clamp(
                110.0,
                140.0,
              ), // Aumentato: 110-140px
            ),
          );
        },
      ),
    );
  }
}

class TicketsSection extends StatefulWidget {
  const TicketsSection({super.key});

  @override
  State<TicketsSection> createState() => _TicketsSectionState();
}

class _TicketsSectionState extends State<TicketsSection> {
  final TicketService _ticketService = TicketService();
  static final Logger _logger = AppLogger.getLogger('TicketsSection');
  TicketDisplayData? _latestTicket;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLatestTicket();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh tickets when dependencies change (e.g., when returning to this page)
    _loadLatestTicket();
  }

  Future<void> _loadLatestTicket() async {
    AppLogger.info(_logger, 'Loading latest ticket...');
    await _ticketService.ready;
    if (mounted) {
      final latestTicket = _ticketService.getLatestTicket();
      final allTickets = _ticketService.getAllTickets();
      AppLogger.info(
        _logger,
        'Found ${allTickets.length} total tickets, latest ticket: ${latestTicket?.eventTitle ?? "null"}',
      );
      setState(() {
        _latestTicket = latestTicket;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('my_tickets'.tr(), style: kSectionTitleTextStyle),
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TicketListPage()),
                );
                appMainKey.currentState?.setTab(2);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'see_all'.tr(),
                    style: const TextStyle(color: lightGreyColor, fontSize: 16),
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

        // Show latest ticket or empty state
        if (_isLoading) ...[
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ] else if (_latestTicket != null) ...[
          MyTicketWidget(
            eventDate: _latestTicket!.eventDate,
            eventTime: _latestTicket!.eventTime,
            eventTitle: _latestTicket!.eventTitle,
            venueAddress: _latestTicket!.venueAddress,
          ),

          const SizedBox(height: 12),

          Center(
            child: TextButton(
              onPressed: () {
                // Show the same ticket details modal as the ticket tap
                MyTicketWidget(
                  eventDate: _latestTicket!.eventDate,
                  eventTime: _latestTicket!.eventTime,
                  eventTitle: _latestTicket!.eventTitle,
                  venueAddress: _latestTicket!.venueAddress,
                )._showTicketDetails(context);
              },
              child: Text(
                'view_details'.tr(),
                style: const TextStyle(color: lightGreyColor, fontSize: 14),
              ),
            ),
          ),
        ] else ...[
          // Empty state when no tickets
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'tickets_empty_state'.tr(),
                  style: TextStyle(
                    color: Colors.grey.withValues(alpha: 0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Vertical barcode widget for ticket sides (no background)
class VerticalBarcodeWidget extends StatelessWidget {
  final String data;
  final double? width;
  final double? height;

  const VerticalBarcodeWidget({
    super.key,
    required this.data,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final containerWidth = width ?? 60; // Aumentato da 40 a 60
    final containerHeight = height ?? 300; // Aumentato da 100 a 120

    return ClipRect(
      child: SizedBox(
        width: containerWidth,
        height: containerHeight,
        child: OverflowBox(
          maxWidth: containerWidth,
          maxHeight: containerHeight,
          child: Transform.rotate(
            angle: 1.5708, // 90 degrees in radians (π/2)
            child: SizedBox(
              width: containerHeight,
              height: containerWidth,
              child: CustomPaint(
                painter: BarcodePainter(data: data),
                size: Size(containerHeight, containerWidth),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
